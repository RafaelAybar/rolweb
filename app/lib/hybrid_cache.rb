require "active_support/cache"

class HybridCache < InterfaceCache

  @@memory_cache ||= ActiveSupport::Cache::MemoryStore.new(size: 50.megabytes) # default memory size

  private(:initialize)
  def initialize(model_class)
    @disk_cache = DiskCache.get_cache(model_class)
  end

  # Asgurar una interfaz identica a DiskCache
  def self.get_cache(model_class) 
    HybridCache.new(model_class)
  end

  # fetches from memory cache first, then from disk cache if not found in memory
  # if a block is given, it will be used to fetch the record if not found in either cache
  # if a block is not given, it will try to find the record in the database
  def fetch(id, &block)
    @@memory_cache.fetch(id) do
      @disk_cache.fetch(id, &block)
    end
  end

  # stores only in cache, not in database
  def store(record)
    raise 'HybridCache.store: record cannot be nil' unless record
    id = record.id
    @@memory_cache.write(id, record)
    @disk_cache.store(record)
  end

  def remove(id)
    @@memory_cache.delete(id)
    @disk_cache.remove(id)
  end
end
