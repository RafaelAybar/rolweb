require 'fileutils'
require 'json'
require 'zlib'
require 'minitar'

module Backup

  DATA_TABLES = ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata"]
  BACKUPS_DIR = Rails.root.join("tmp", "backups")
  FileUtils.mkdir_p(BACKUPS_DIR) unless Dir.exist?(BACKUPS_DIR)
  

  
  def self.images_dir(dir)
    images_path = dir.join("images")
    FileUtils.mkdir_p(images_path) unless Dir.exist?(images_path)
    images_path
  end



  # Create a backup of the database and Minio images
  def self.prepare_backup_files(temp_dir)
    Rails.logger.info "Preparing backup files in #{temp_dir}"
    FileUtils.mkdir_p(temp_dir)

    Rails.logger.info "Dumping database..."
    data = (DATA_TABLES).map do |table|
      [table, ActiveRecord::Base.connection.select_all("SELECT * FROM #{table}").to_a]
    end.to_h
    File.write(temp_dir.join("database.json"), JSON.generate(data))
    
    Rails.logger.info "Trying to download from Minio..."
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
    Rails.logger.info "Starting backup process..."
    backup_name = "backup_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
    temp_dir = BACKUPS_DIR.join(backup_name)
    backup_path = BACKUPS_DIR.join("#{backup_name}.tar.gz")

    begin
      prepare_backup_files(temp_dir)

      Rails.logger.info "Packing backup files into #{backup_path} from #{temp_dir}..."
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
    
    Rails.logger.info "Testing if conection to Minio is working..."
    begin
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
    rescue Aws::S3::Errors::ServiceError => e
      Rails.logger.info "Couldn't connect to Minio: #{e.message}"
      Rails.logger.info "Skipping Minio images restoration."
    end

    Rails.logger.info "📂 Restoring database..."
    data = JSON.parse(File.read(restore_dir.join("database.json")))
    data.each do |table, records|
      records.each do |record|
        ActiveRecord::Base.connection.insert_fixture(record, table)
      end
    end
  
    Rails.logger.info "✅ Restauración completada con éxito."
  end



  def self.restore(file_path)
    Rails.logger.info "📦 Restaurando backup desde #{file_path}"
    restore_id = Time.now.utc.strftime("%Y%m%d%H%M%S")

    Rails.logger.info "Preparando copia temporal para restaurar..."
    snapshot_path = BACKUPS_DIR.join("snapshot_#{restore_id}")
    prepare_backup_files(snapshot_path)
    begin
      restore_dir = BACKUPS_DIR.join("restore_#{restore_id}")
      FileUtils.mkdir_p(restore_dir)
      
      Rails.logger.info "📥 Unpacking files"
      Zlib::GzipReader.open(file_path) do |gz|
        Minitar.unpack(gz, restore_dir)
      end

      Backup.brave_restore(restore_dir)

    rescue => e
      Rails.logger.error "❌ Error durante restauración: #{e.message} in #{e.backtrace.first}"
      Rails.logger.error e.backtrace.join("\n")
      Rails.logger.info "🔁 Revirtiendo a estado anterior..."
      Backup.brave_restore(snapshot_path)
      Rails.logger.info "✅ Restauración revertida al estado anterior."
    ensure
      FileUtils.rm_rf(restore_dir)
      FileUtils.rm_rf(snapshot_path)
    end
  end

end