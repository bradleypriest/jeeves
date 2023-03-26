class CachedSet
  def initialize(cache, key:)
    @cache = cache
    @key   = key
  end

  def push(value)
    prev = @cache.read(@key) || []
    prev.append(value)
    @cache.write(@key, prev)
  end

  def clear
    @cache.delete(@key)
  end
end 