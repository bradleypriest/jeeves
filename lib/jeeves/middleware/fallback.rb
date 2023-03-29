require 'http'

class Jeeves
  class Middleware
    class FallbackMiddleware
      def logger
        @application.logger
      end

      def client
        @client ||= HTTP.headers({
          "Content-Type" => "application/json"
        }).auth("Bearer #{ENV['OPENAI_API_KEY']}")
      end

      def process(text)
        logger.debug("GPT Query: '#{text}'")
        response = client.post("https://api.openai.com/v1/chat/completions", json: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "system",
              content: "
                You are acting as an automated home assistant, when sent a message from the user, either
                a) if it is a question, provide an answer, or
                b) provide an action in the form of [Actor](action|context).
                If the query requires realtime information (and only if it requires realtime information) and you are unable to answer it, do not ignore the question, respond with a statement including placeholder values that can be filled in by the same action system as above.
                The text may come in garbled as it is being transcribed from speech, so try to work out what the user means if a statement sounds similar to a reasonable request.
                The currently available actions are: MusicPlayer, WeatherService, ExchangeRate, DateAndTime, ShoppingList, SmartHome, NewsService, AnimalSounds
              "
            },
            { role: "system", content: "The user's current timezone is PDT, use this timezone when answering any questions related to time and date" },
            { role: "user", content: "Message: Play last wish by pearl jam" },
            { role: "assistant", content: "Response: [MusicPlayer](Play song|last wish by pearl jam)"},
            { role: "user", content: "Message: What time is it in Auckland, New Zealand right now?" },
            { role: "assistant", content: "Response: The time in Auckland is [DateAndTime](Current time|NZDT)"},
            { role: "user", content: "Message: What is the weather like today?" },
            { role: "assistant", content: "Response: [WeatherService](Current weather|San Francisco, CA)"},
            { role: "user", content: "Message: What is the exchange rate between New Zealand Dollar and US Dollar?" },
            { role: "assistant", content: "Response: [ExchangeRate](Current exchange rate|NZD:USD)"},
            { role: "user", content: "Message: What is the capital of California?" },
            { role: "assistant", content: "Response: The capital of California is Sacramento" },
            { role: "user", content: text }
          ]
        })
        message = response.parse['choices'][0]['message']['content']
        logger.debug("GPT Response: #{message}")
        message
      end
    end
  end
end
