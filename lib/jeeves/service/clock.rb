require 'tzinfo'

class Jeeves
  class Service
    class Clock
      def process(action, timezone)
        case action
        when "CurrentTime"
          [TZInfo::Timezone.get(timezone).now.strftime("%-I:%-M%p")]
        when "CurrentDate"
          [TZInfo::Timezone.get(timezone).now.strftime("%A %-d %B")]
        end
      end
    end
  end
end
