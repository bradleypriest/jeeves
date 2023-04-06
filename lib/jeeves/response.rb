require 'strscan'

class Jeeves
  class Response
    Token = Data.define(:actor, :action, :context)

    def initialize(application, message)
      @application = application
      @original = message.dup
      @message = message
      @tokens = extract_tokens
      @actions = []
    end

    def parse
      process_tokens
      puts @actions
      puts "\e[32m#{@message}\e[0m"
    end

  private

    def extract_tokens
      scanner = StringScanner.new(@message)
      tokens = {}
      until scanner.eos?
        portion = scanner.scan_until(/\[(\w+)\]\((\w+)(?:\|(.+?))?\)/)
        if portion.nil?
          scanner.terminate
          next
        else
          tokens[scanner[0]] = Token.new(scanner[1], scanner[2], scanner[3])
        end
      end
      tokens
    end

    def process_tokens
      @tokens.each do |token, data|
        processed = process_token(data)
        case processed
        when Array
          @message.gsub!(token, processed[0])
          @actions.push(processed[1])
        when String
          @message.gsub!(token, processed)
        when NilClass
          @application.logger.error "Unable to process Token: #{token}"
          puts "Unable to process Token: #{token}"
        end
      end
    end

    def process_token(data)
      Jeeves::Service.const_get(data.actor).new.tap do |service|
        service.instance_variable_set(:@cache, @application.cache.instance_variable_get(:@cache))
      end.process(data.action, data.context)
    rescue => ex
      @application.logger.error(ex)
      nil
    end
  end
end
