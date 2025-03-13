require "fileutils"
require "stringio"

class DiskCache
  CACHE_DIR = Rails.root.join('tmp', 'cache', 'hybrid_cache')
  FileUtils.mkdir_p(CACHE_DIR) unless Dir.exist?(CACHE_DIR)

  def initialize(model_class)
    @model_class = model_class
    @disk_cache_path = CACHE_DIR.join(model_class.name.underscore)
    FileUtils.mkdir_p(@disk_cache_path) unless Dir.exist?(@disk_cache_path)
  end
  
  def disk_cache_file(id)
    @disk_cache_path.join("#{id}.cache")
  end

  def fetch(id)
    cache_path = disk_cache_file(id)
    if File.exist?(cache_path)
      Marshal.load(StringIO.new(File.read(cache_path)).read)
    else
      record = @model_class.find_by(id: id)
      return nil unless record
      store(record)
      record
    end
  end

  # stores only in cache, not in database
  def store(record)
    raise 'HybridCache.store: record cannot be nil' unless record
    File.open(disk_cache_file(record.id), 'wb') do |f|
      f.write(Marshal.dump(record))
    end
  end

  def remove(id)
    FileUtils.rm_f(disk_cache_file(id))
  end

  def self.clear_disk_cache!
    Dir.glob("#{CACHE_DIR}/*/*").each do |file|
      FileUtils.rm_f(file)
    end
    Rails.logger.info "HybridCache: Disk cache cleared completely, subdirectories preserved."
  end
end
