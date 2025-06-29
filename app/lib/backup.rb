require 'fileutils'
require 'json'
require 'zlib'
require 'minitar'

module Backup

  BACKUPS_DIR = Rails.root.join("tmp", "backups")

  class YielderIO
    def initialize(yielder)
      @yielder = yielder
    end

    def write(data)
      @yielder << data
    end
  end

  def self.create
    Rails.logger.info "Starting backup process..."

    Rails.logger.info "Ensuring backup directory exists..."
    FileUtils.mkdir_p(BACKUPS_DIR) unless Dir.exist?(BACKUPS_DIR)
    timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
    temp_dir = BACKUPS_DIR.join("backup_#{timestamp}")
    FileUtils.mkdir_p(temp_dir)


    Rails.logger.info "Dumping database..."
    data = (ActiveRecord::Base.connection.tables - ["schema_migrations", "ar_internal_metadata"]).map do |table|
      [table, ActiveRecord::Base.connection.select_all("SELECT * FROM #{table}").to_a]
    end.to_h
    File.write(temp_dir.join("database.json"), JSON.generate(data))
    

    Rails.logger.info "Testing if conection to Minio is working..."
    begin
      uper = MinioImageUploader.new
      Rails.logger.info "Dowloading Minio images to #{temp_dir}..."
      imgdir = temp_dir.join("images")
      FileUtils.mkdir_p(imgdir)
      uper.all_ids.each do |id|
        img = uper.get(id)
        File.binwrite(imgdir.join(id), img.data)
      end
      Rails.logger.info "✅ Minio images download completed."
    rescue Aws::S3::Errors::ServiceError => e
      Rails.logger.info "Couldn't to connect to Minio: #{e.message}"
      Rails.logger.info "Skipping Minio images backup."
    end
    
    
    Enumerator.new do |output_stream|
      Rails.logger.info "Packing backup files into tar.gz..."
      begin
        Zlib::GzipWriter.wrap(YielderIO.new(output_stream)) do |gz|
          Dir.chdir(temp_dir) do
            Minitar.pack(Dir["*"], gz)
          end
        end
        Rails.logger.info "✅ Backup created :D filename=backup_#{timestamp}.tar.gz"
      ensure
        FileUtils.rm_rf(temp_dir)
      end
    end
  end

  def self.restore(file_path)
  end
end