#!/usr/bin/env ruby

require './jeeves'

module InputHandler
  WEIRDNESSES = [
    'Thank you.',
    'Thank you!',
    'Thank you for watching.',
    'Thank you for watching!',
    'Thanks for watching.',
    'Thanks for watching!',
    'Thanks for watching guys!',
  ].freeze

  def self.handler
    @handler ||= Jeeves.new
  end

  def self.process_line(line)
    line.rstrip!
      case line
      when "Message:"
        # no-op for now
      when "Now Listening"
        puts line
      when /\AMessage: /
        message = line.split("Message: ")[1]
        if WEIRDNESSES.include?(message)
          # Whisper has some ghosts in the machine, so ignore them for now
        else
          handler.process(message)
        end
      else
        puts "Unknown: '#{line}'"
      end
  end
end

while true do
  begin
    STDIN.each_line do |line|
      InputHandler.process_line(line)
    end
  rescue => ex
    puts ex
    puts ex.backtrace
  end
  sleep 0.5
end
