#!/usr/bin/env ruby

require 'Shellwords'

BRIDGE_FILE = File.join(File.dirname(__FILE__), "lib", "bridge.rb")
command = "irb | #{Shellwords.escape(BRIDGE_FILE)}"

pipe = IO.popen(command, "w")
ARGF.each do |line|
  pipe.write(line)
end