require 'active_support'
require 'redis'
require './lib/jeeves/cache'
require './lib/jeeves/middleware'
require './lib/jeeves/response'
Dir["./lib/jeeves/service/*.rb"].each {|file| require file }

class Jeeves
  attr_reader :cache, :logger

  def initialize
    @cache = Cache.new
    @history = @cache.cached_set(key: :history)
    @stack = Middleware.new.build_stack(application: self)
    @logger = ActiveSupport::Logger.new('logs/development.log').tap do |l|
      l.formatter = Logger::Formatter.new
    end
  end

  def process(text)
    @history.add(text)

    message = @stack.lazy.filter_map do |middleware, _|
      middleware.process(text)
    end.first

    if message.is_a?(String)
      Response.new(self, message).parse
    else
      raise message
    end
  end
end
