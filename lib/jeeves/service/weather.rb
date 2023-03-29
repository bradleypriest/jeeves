class Jeeves
  class Service
    class Weather
      def process(action, location)
        case action
        when 'CurrentWeather'
          weather_json = get_weather(*geocode(location))
          "The weather is #{weather_json['temperature'].round} degrees with #{weather_code(weather_json['weathercode'])}"
        end
      end

    private

      def geocode(location)
        existing = @cache.hget('geo', location)
        if existing
          existing.split(',')
        else
          data = HTTP.get("https://geocoding-api.open-meteo.com/v1/search", params: { name: location }).parse['results'][0]
          @cache.hset('geo', location, [data['latitude'], data['longitude']].join(','))
          [data['latitude'], data['longitude']]
        end
      end

      # JSON Object:
      #  temperature: 10.7
      #  windspeed: 11.3
      #  winddirection: 248
      #  weathercode: 3
      #  time	"2023-03-29T15:00"
      def get_weather(lat, lng)
        HTTP.get("https://api.open-meteo.com/v1/forecast", params: { latitude: lat, longitude: lng, current_weather: true }).parse['current_weather']
      end

      def weather_code(code)
        case code
        when 0 then "Clear sky"
        when 1 then "Mainly clear"
        when 2 then "Partly cloudy"
        when 3 then "Overcast"
        when 45, 48 then "Fog"
        when 51 then "Light drizzle"
        when 53, 55, 56, 57 then "Drizzle"
        when 61, 80 then "Light rain"
        when 63, 65, 66, 67, 81, 82 then "Rain"
        when 71, 73, 75, 77, 85, 86 then "Snow"
        when 95, 96, 99 then "Thunderstorms"
        end
      end
    end
  end
end

