class CachedSet
  def initialize(cache, key:)
    @cache = cache
    @key   = key
  end

  def add(value)
    @cache.sadd(@key, value)
  end

  def clear
    @cache.delete(@key)
  end
end
