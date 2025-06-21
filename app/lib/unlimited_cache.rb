module UnlimitedCache
  
  @@memory_cache ||= ActiveSupport::Cache::MemoryStore.new

  def cache_fetch key
    @@memory_cache.fetch(key, expires_in: 1.weeks) do
      yield
    end
  end

  def cache_delete key
    @@memory_cache.delete(key)
  end
end