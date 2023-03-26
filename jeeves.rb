require 'active_support'
require './lib/jeeves/cache'
require './lib/jeeves/middleware'

class Jeeves
  def initialize
    @cache = Cache.new
    @history = @cache.cached_set(key: :history)
    @stack = Middleware.new.build_stack(cache: @cache)
  end

  def process(text)
    @history.push(text)

    @stack.detect do |middleware|
      middleware.process(text)
    end
  end
end
