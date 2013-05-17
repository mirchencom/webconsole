#!/usr/bin/env ruby

require "./lib/parser"

# A data structure to represent a match:
# 1. match_text
# 2. match_start
# 3. match_end



ARGF.each do |line|
  # puts line + "\n\nANEWLINE\n\n"

  match = Match.new(line)

  # puts match.filepath
  # puts match.line_number

  # Parse a line:

  # 1. if the filepath doesn't match the current filepath, create a new data structure


  # processed_line = line
  # processed_line.gsub!(/\[1.+?m(.*)$/, '<a>\1</a>')
  # puts processed_line
end