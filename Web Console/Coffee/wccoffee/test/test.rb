#!/usr/bin/env ruby

require 'shellwords'

testinput = %Q[add = (x, y)->
	x + y
console.log add(1, 2)]

testinput.gsub!("\n", "\uFF00")
testinput = testinput + "\n"

puts "testinput = " + testinput.inspect

# WCCOFFEE_EXECUTABLE = File.expand_path(File.join(File.dirname(__FILE__), "wccoffee.rb"))
# puts Shellwords.escape(WCCOFFEE_EXECUTABLE)

require File.join(File.dirname(__FILE__), "..", "lib", "wrapper")

wrapper = WcCoffee::Wrapper.new("coffee")

wrapper.parse_input(testinput)

ARGF.each do |line|
  puts line
end

