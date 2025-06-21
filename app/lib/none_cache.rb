class NoneCache < InterfaceCache
  def self.get_cache(model_class)
    NoneCache.new
  end
  def fetch(id, &block)
    yield if block_given?
    nil
  end
  def store(record)
  end
  def remove(id)
  end
end