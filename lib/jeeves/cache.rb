require './lib/jeeves/cached_set'

class Jeeves
  class Cache
    def initialize
      @cache = Redis.new(db: 15)
    end

    def cached_set(key:)
      CachedSet.new(@cache, key: key)
    end
  end
end
