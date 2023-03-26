class Jeeves
  class Middleware
    class FallbackMiddleware
      def initialize(_)
      end

      def process(text)
        puts "I heard: \"#{text}\""
      end
    end
  end
end