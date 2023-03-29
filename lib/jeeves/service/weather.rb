class Jeeves
  class Service
    class Weather
      def process(action, location)
        case action
        when 'CurrentWeather'
          get_weather(*geocode(location))
          nil # TODO
        end
      end

    private

      def geocode(location)
        existing = @cache.hget('geo', location)
        if existing
          puts "Geocoding 1"
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
    end
  end
end

# 0 	Clear sky
# 1, 2, 3 	Mainly clear, partly cloudy, and overcast
# 45, 48 	Fog and depositing rime fog
# 51, 53, 55 	Drizzle: Light, moderate, and dense intensity
# 56, 57 	Freezing Drizzle: Light and dense intensity
# 61, 63, 65 	Rain: Slight, moderate and heavy intensity
# 66, 67 	Freezing Rain: Light and heavy intensity
# 71, 73, 75 	Snow fall: Slight, moderate, and heavy intensity
# 77 	Snow grains
# 80, 81, 82 	Rain showers: Slight, moderate, and violent
# 85, 86 	Snow showers slight and heavy
# 95 * 	Thunderstorm: Slight or moderate
# 96, 99 * 	Thunderstorm with slight and heavy hail
