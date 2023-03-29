#!/usr/bin/env ruby

require './jeeves'

handler = Jeeves.new

while true do
  begin
    STDIN.each_line do |line|
      line.rstrip!
      if line.start_with?("Message: ")
        handler.process(line.split("Message: ")[1])
      elsif line == "Message:"
        # no-op for now
      elsif line == "Now Listening"
        puts line
      else
        puts "Unknown: '#{line}'"
      end
    end
  rescue => ex
    puts ex
    puts ex.backtrace
  end
  sleep 0.5
end
