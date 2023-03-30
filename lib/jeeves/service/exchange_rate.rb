class Jeeves
  class Service
    class ExchangeRate
      def process(action, context)
        case action
        when "CurrentRate"
          "The exchange rate is 0.65"
        end
      end
    end
  end
end
