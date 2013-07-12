#!/usr/bin/env ruby

require 'Shellwords'

ARGF.each do |line|
  string = "from ruby = " + line
  `osascript displaydialog.scpt #{Shellwords.escape(string)}`
end