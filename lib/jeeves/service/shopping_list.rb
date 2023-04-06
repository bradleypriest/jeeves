class Jeeves
  class Service
    class ShoppingList
      KEY = "shopping"

      def process(action, context)
        case action
        when "AddItem", "AddToList"
          @cache.sadd(KEY, context)
          "#{context} added to your shopping list"
        when "RemoveItem"
          @cache.srem(KEY, context)
          "Removed #{context} to your shopping list"
        when "ListItems"
          items = @cache.smembers(KEY)
          "Your shopping list is currently #{to_sentence(items)}"
        end
      end

    private

    def to_sentence(items)
        case items.length
        when 0
          "empty"
        when 1
          items.first
        when 2
          items.join(" and ")
        else
          "#{items[0...-1].join(", ")} and #{items[-1]}"
        end
      end
    end
  end
end
