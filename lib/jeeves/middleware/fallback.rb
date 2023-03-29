require 'http'

class Jeeves
  class Middleware
    class FallbackMiddleware

      def client
        @client ||= HTTP.headers({
          "Content-Type" => "application/json"
        }).auth("Bearer #{ENV['OPENAI_API_KEY']}")
      end

      def initialize(_)
      end

      def process(text)
        puts "Sending query '#{text}' to GPT-3"
        response = client.post("https://api.openai.com/v1/chat/completions", json: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system", content: "You are acting as an automated home assistant, when sent a message from the user, either a) if it is a question, provide an answer, or b) provide an action in the form of [Actor](action|context). The text may come in a little bit garbled as it is being transcribed from speech, so try to work out what the user means if a statement sounds similar to a reasonable request" },
            { role: "system", content: "Your current timezone is PDT, your location is San Francisco, California, and your zipcode is 94115" },
            { role: "user", content: "Message: Play last wish by pearl jam" },
            { role: "assistant", content: "Response: [Music Player](Play song|last wish by pearl jam)"},
            { role: "user", content: "Message: What is the capital of California?" },
            { role: "assistant", content: "Response: The capital of California is Sacramento" },
            { role: "user", content: text }
          ]
        })
        puts response.parse['choices'][0]['message']['content']
      end
    end
  end
end
