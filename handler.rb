#!/usr/bin/env ruby

require './jeeves'

handler = Jeeves.new

while true do
  begin
    STDIN.each_line do |line|
      if line.start_with?("Message: ")
        handler.process(line.split("Message: ")[1].chomp)
      else
        print line
      end
    end
  rescue => ex
    puts ex
  end
  sleep 0.5
end