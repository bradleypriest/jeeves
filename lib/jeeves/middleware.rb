Dir["./lib/jeeves/middleware/*.rb"].each {|file| require file }

class Jeeves
  class Middleware
    def self.middleware
      @middleware ||= []
    end

    def self.register_middleware(name)
      middleware.push(name)
    end

    register_middleware :whisper
    register_middleware :time
    register_middleware :fallback

    def build_stack(cache)
      self.class.middleware.map do |name|
        middleware_name = ActiveSupport::Inflector.classify("#{name}_middleware")
        self.class.const_get(middleware_name).new(cache)
      end
    end
  end
end
