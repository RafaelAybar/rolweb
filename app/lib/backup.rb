require 'fileutils'
require 'json'
require 'zlib'
require 'minitar'

module Backup

  DATA_TABLES = ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata"]
  BACKUPS_DIR = Rails.root.join("tmp", "backups")
  FileUtils.mkdir_p(BACKUPS_DIR) unless Dir.exist?(BACKUPS_DIR)
  

  def self.time_now
    Time.current.strftime("%Y-%m-%d_%H-%M-%S")
  end
  
  def self.images_dir(dir)
    images_path = dir.join("images")
    FileUtils.mkdir_p(images_path) unless Dir.exist?(images_path)
    images_path
  end
  


  def self.silence_sql
    original_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = Logger.new(IO::NULL)
    yield
  ensure
    ActiveRecord::Base.logger = original_logger
  end



  # Create a backup of the database and Minio images
  def self.prepare_backup_files(temp_dir)
    Rails.logger.info "🔧 Preparing backup files in #{temp_dir}"
    FileUtils.mkdir_p(temp_dir)

    Rails.logger.info "💾 Dumping database..."
    data = (DATA_TABLES).map do |table|
      [table, ActiveRecord::Base.connection.select_all("SELECT * FROM #{table}").to_a]
    end.to_h
    File.write(temp_dir.join("database.json"), JSON.generate(data))

    Rails.logger.info "📋 Dumping database schema..."
    schema = DATA_TABLES.to_h do |table|
      [table, ActiveRecord::Base.connection.columns(table).map(&:name).sort]
    end
    File.write(temp_dir.join("schema.json"), JSON.pretty_generate(schema))
    
    Rails.logger.info "🌐 Trying to download from Minio..."
    begin
      uper = MinioImageUploader.new
      imgdir = Backup.images_dir(temp_dir)
      metadata = []
      uper.all_ids.each do |id|
        img = uper.get(id)
        File.binwrite(imgdir.join(id), img.data)
        metadata << {
          id: id,
          original_filename: img.nombre,
          content_type: img.content_type || "application/octet-stream"
        }
      end
      File.write(temp_dir.join("images_meta.json"), JSON.generate(metadata))
      Rails.logger.info "✅ Minio images download completed."
      rescue MinioConnectionError => e
        Rails.logger.warn "⚠️ Skipping Minio image backup: #{e.message}"
    end
  end



  def self.create
    Rails.logger.info "🚀 Starting backup process..."
    backup_name = "backup_#{time_now}"
    temp_dir = BACKUPS_DIR.join(backup_name)
    backup_path = BACKUPS_DIR.join("#{backup_name}.tar.gz")

    begin
      prepare_backup_files(temp_dir)

      Rails.logger.info "📦 Packing backup files into #{backup_path} from #{temp_dir}..."
      Zlib::GzipWriter.open(backup_path) do |gz|
        Dir.chdir(temp_dir) do
          Minitar.pack(Dir["*"], gz)
        end
      end
      Rails.logger.info "✅ Backup created :D"
      backup_path
    ensure
      FileUtils.rm_rf(temp_dir)
    end
  end



  def self.brave_restore(restore_dir)

    Rails.logger.info "🧹 Deleting database..."
    ActiveRecord::Base.transaction do
      (DATA_TABLES).each do |table|
        ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
      end
    end
    
    begin
      Rails.logger.info "🔍 Testing if conection to Minio is working..."
      uper = MinioImageUploader.new
      Rails.logger.info "🗑️ Deleting Minio images..."
      uper.clear_all!
      Rails.logger.info "✅ Minio images deleted."

      Rails.logger.info "📷 Restoring images..."
      metadata = JSON.parse(File.read(restore_dir.join("images_meta.json")))
      imgdir = Backup.images_dir(restore_dir)
      metadata.each do |entry|
        id = entry["id"]
        file_path = imgdir.join(id)
        uper.store(
          id: id,
          data: File.binread(file_path),
          content_type: entry["content_type"],
          original_filename: entry["original_filename"]
        )
      end
    rescue MinioConnectionError => e
      Rails.logger.warn "⚠️ Skipping Minio images restoration: #{e.message}"
    end

    Rails.logger.info "📂 Restoring database..."
    data = JSON.parse(File.read(restore_dir.join("database.json")))
    data.each do |table, records|
      records.each do |record|
        ActiveRecord::Base.connection.insert_fixture(record, table)
      end
    end
  
    Rails.logger.info "✅ Database restored successfully."
  end



  def self.restore(file_path)
    Rails.logger.info "📦 Restoring backup from #{file_path}"
    restore_id = time_now
    restore_dir = BACKUPS_DIR.join("restore_#{restore_id}")
    FileUtils.mkdir_p(restore_dir)
    
    Rails.logger.info "📥 Unpacking files"
    Zlib::GzipReader.open(file_path) do |gz|
      Minitar.unpack(gz, restore_dir.to_s)
    end

    Rails.logger.info "🔍 Validating Database schema..."
    backup_schema  = JSON.parse(File.read(restore_dir.join("schema.json")))
    check_schema_matches!(backup_schema )

    Rails.logger.info "💾📸💾 Preparing snapshot copy for rollback..."
    snapshot_path = BACKUPS_DIR.join("snapshot_#{restore_id}")
    silence_sql do
      prepare_backup_files(snapshot_path)
    end 

    begin
      silence_sql do
        Backup.brave_restore(restore_dir)
      end
    rescue => e
      Rails.logger.error "❌ Error during restoration: #{e.message}"
      Rails.logger.error "🔁 Reverting to previous state..."
      silence_sql do
        Backup.brave_restore(snapshot_path)
      end
      Rails.logger.info "✅ Successfully reverted."
      raise
    ensure
      FileUtils.rm_rf(restore_dir)
      FileUtils.rm_rf(snapshot_path)
    end
  end



  def self.check_schema_matches!(backup_schema)
    current_schema = DATA_TABLES.to_h do |table|
      [table, ActiveRecord::Base.connection.columns(table).map(&:name).sort]
    end

    errors = []

    missing_tables = backup_schema.keys - current_schema.keys
    unless missing_tables.empty?
      errors << "Tables present in the backup but missing in the current DB: #{missing_tables.join(', ')}"
    end
    extra_tables = current_schema.keys - backup_schema.keys
    unless extra_tables.empty?
      errors << "Tables present in the current DB but missing in the backup: #{extra_tables.join(', ')}"
    end

    (backup_schema.keys & current_schema.keys).each do |table|
      expected = backup_schema[table]
      actual = current_schema[table]
      if expected != actual
        missing_cols = expected - actual
        extra_cols = actual - expected

        msg = "Column differences in table '#{table}':"
        msg += " missing in current => [#{missing_cols.join(', ')}]" unless missing_cols.empty?
        msg += " | extra in current => [#{extra_cols.join(', ')}]" unless extra_cols.empty?
        errors << msg
      end
    end

    unless errors.empty?
      raise "Database schema mismatch:\n- #{errors.join("\n- ")}"
    end
  end
end