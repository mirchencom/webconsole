#!/usr/bin/env ruby

require 'Shellwords'

BRIDGE_FILE = File.join(File.dirname(__FILE__), "lib", "bridge.rb")
command = "coffee | #{Shellwords.escape(BRIDGE_FILE)}"

pipe = IO.popen(command, "w")
ARGF.each do |line|
  # TODO I think I just want to write the line to the window_manager here
  pipe.write(line)
end
