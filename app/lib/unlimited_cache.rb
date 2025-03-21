module UnlimitedCache
  
  @@memory_cache ||= ActiveSupport::Cache::MemoryStore.new

  def cache_fetch key
    Rails.logger.debug "UnlimitedCache.cache_fetch: key: #{key}"
    @@memory_cache.fetch(key, expires_in: 1.weeks) do
      Rails.logger.debug "UnlimitedCache.cache_fetch: cache missed!"
      yield
    end
  end

  def cache_delete key
    Rails.logger.debug "UnlimitedCache.cache_delete: key: #{key}"
    @@memory_cache.delete(key)
  end
end