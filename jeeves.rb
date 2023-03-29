require 'active_support'
require './lib/jeeves/cache'
require './lib/jeeves/middleware'

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
    @history.push(text)

    output = @stack.lazy.filter_map do |middleware, _|
      middleware.process(text)
    end.first

    hydrate output
  end

  def hydrate(message)
    if message.is_a?(String)
      puts message
    else
      puts "CHECK ME: #{message}"
    end
  end
end
