require 'active_support'

class Jeeves
  def initialize
    @history = History.new
  end

  def process(text)
    @history << text
    puts "I heard: \"#{text}\""
  end

  class History
    KEY = "jeeves"

    def initialize
      @cache = ActiveSupport::Cache::FileStore.new("tmp/cache")
      @cache.clear
    end

    def <<(value)
      prev = @cache.read(KEY) || []
      prev.append(value)
      @cache.write(KEY, prev)
    end
  end
end
