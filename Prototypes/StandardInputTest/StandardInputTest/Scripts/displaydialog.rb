#!/usr/bin/env ruby

require 'Shellwords'

puts "Script start"
ARGF.each do |line|
  puts "the passed in value is " + line
  string = "from ruby = " + line
  # puts "sending #{string} to ruby"
  `osascript displaydialog.scpt #{Shellwords.escape(string)}`
end