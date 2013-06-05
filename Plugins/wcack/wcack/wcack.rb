#!/usr/bin/env ruby

require "./lib/parser"


WcAck.load(ARGF.read)

# ARGF.each do |line|
#   # puts line + "\n\nANEWLINE\n\n"
# 
#   parsed_line = ParsedLine.new(line)
# 
# puts "parsed_line = " + parsed_line.inspect
# 
#   # puts match.filepath
#   # puts match.line_number
# 
#   # Parse a line:
# 
#   # 1. if the filepath doesn't match the current filepath, create a new data structure
# 
# 
#   # processed_line = line
#   # processed_line.gsub!(/\[1.+?m(.*)$/, '<a>\1</a>')
#   # puts processed_line
# end