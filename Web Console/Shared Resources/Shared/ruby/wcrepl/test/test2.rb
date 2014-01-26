#!/usr/bin/env ruby

require 'shellwords'

testinput = %Q[add = (x, y)->
	x + y
console.log add(1, 2)]

testinput.gsub!("\t", "\s\s\s\s")
testinput.gsub!("\n", "\uFF00")
testinput = testinput + "\n"

puts "testinput = " + testinput.inspect

require File.join(File.dirname(__FILE__), "..", "wcrepl")

wrapper = WcREPL::Wrapper.new("coffee")

wrapper.parse_input(testinput)

ARGF.each do |line|
  puts line
end

