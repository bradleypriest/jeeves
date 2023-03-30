class Jeeves
  class Service
    class Stopwatch
      def process(action, context)
        case action
        when "StartTimer"
          ["Timer set for #{context}", -> { "TODO: set timer" }]
        end
      end
    end
  end
end
