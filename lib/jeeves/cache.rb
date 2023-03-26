require './lib/jeeves/cached_set'

class Jeeves
  class Cache
    def initialize
      @cache = ActiveSupport::Cache::FileStore.new("tmp/cache")
    end

    def cached_set(key:)
      CachedSet.new(@cache, key: key)
    end
  end
end