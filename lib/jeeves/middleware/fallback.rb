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
                b) provide an action in the form of [Actor](action|context), or
                c) If you are unable to respond to a query that requires realtime information that you don't have access to, respond with a statement including placeholder values in the same format as above.
                The text may come in garbled as it is being transcribed from speech, so try to work out what the user means if a statement sounds similar to a reasonable request.
                Where possible return brief responses as opposed to extensive ones unless requested otherwise.
                The currently available actions are: MusicPlayer, Stopwatch, Weather, ExchangeRate, ShoppingList, SmartHome, NewsService, AnimalSounds
              "
            },
            { role: "system",
              content: "
              The user's current timezone is America/Los_Angeles, use this timezone when answering any questions related to time and date.
              The user's current location is San Francisco.
              The current time in UTC is '#{Time.now.utc}'.
              "
            },
            { role: "user", content: "Message: Play last wish by pearl jam" },
            { role: "assistant", content: "Response: [MusicPlayer](PlaySong|Last Wish by Pearl Jam)"},
            { role: "user", content: "Message: What is the weather like today?" },
            { role: "assistant", content: "Response: [Weather](CurrentWeather|San Francisco)"},
            { role: "user", content: "Message: What is the exchange rate between New Zealand Dollar and US Dollar?" },
            { role: "assistant", content: "Response: [ExchangeRate](CurrentRate|NZD:USD)"},
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
