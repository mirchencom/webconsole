#!/usr/bin/env ruby

require 'shellwords'

testinput = %Q[def add_numbers(num1, num2)
  return num1 + num2
end
add_numbers(3, 4)]

testinput.gsub!("\n", "\uFF00")
testinput = testinput + "\n"

puts "testinput = " + testinput.inspect

# WCCOFFEE_EXECUTABLE = File.expand_path(File.join(File.dirname(__FILE__), "wccoffee.rb"))
# puts Shellwords.escape(WCCOFFEE_EXECUTABLE)

require File.join(File.dirname(__FILE__), "..", "lib", "wrapper")

wrapper = WcIRB::Wrapper.new

wrapper.parse_input(testinput)

ARGF.each do |line|
  puts line
end

