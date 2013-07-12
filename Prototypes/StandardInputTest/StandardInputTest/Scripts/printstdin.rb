#!/usr/bin/env ruby

puts "Script start"
ARGF.each do |line|
  puts "from ruby" + line
end