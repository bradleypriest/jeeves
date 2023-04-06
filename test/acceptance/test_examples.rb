require "minitest/autorun"
require "./jeeves"

class TestExamples < Minitest::Test
  def test_examples
    [
      "add canola oil and toilet paper to the shopping list",
      "add cello tape to the shopping list",
      "add cocoa to the shopping list",
      "add coke zero to the shopping list",
      "add lemons to shopping list",
      "add milk to the shopping list",
      "add salted butter to the shopping list",
      "add toothpaste to the shopping list",
      "add vanilla ice cream to shopping list",
      "add washing powder to the shopping list",
      "add eggs to the shopping list",
      "add paper towels to the shopping list",
      "add pita bread to the shopping list",
      "play spotify",
      "next song",
      "pause",
      "play in this room",
      "play music",
      "play",
      "start jeeves",
      "volume down",
      "volume up",
      "what temperature is it in san francisco today",
      "what temperature is it outside today",
      "what temperature is it outside",
      "what temperature is it right now",
      "what's that in celsius",
      "what's the current time in singapore",
      "what's the time in singapore",
      "what's the time",
      "clean the kitchen",
      "how much time on my timer",
      "play five oh five by the arctic monkeys",
      "set a timer for four minutes",
      "set the timer for eight minutes",
      "start the roomba",
      "stop playing music in the office",
      "stop the music",
      "vacuum the kitchen",
      "what is my weekend celebration routine consist of",
      "what temperature is it in san francisco right now",
      "what's the temperature outside",
      "what's the time in new zealand right now",
      "what's the weather in san francisco right now",
      "who's playing"
    ].each do |message|
      puts %|Processing "\e[34m#{message}\e[0m"|
      Jeeves.new.process(message)
    end
  end
end

