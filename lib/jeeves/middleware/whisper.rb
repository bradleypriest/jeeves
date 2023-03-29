class Jeeves
  class Middleware
    class WhisperMiddleware
      # Whisper has some ghosts in the machine, so ignore them for now
      WEIRDNESSES = [
        'Thank you.',
        'Thank you for watching.',
        'Thanks for watching.',
        'Thank you for watching!'
      ].freeze

      def initialize(_)
      end

      def process(text)
        return true if WEIRDNESSES.include?(text)
      end
    end
  end
end

