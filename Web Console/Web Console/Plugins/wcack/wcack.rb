#!/usr/bin/env ruby

require "./lib/parser"

module WcAck
  class WebConsoleBridge
    def added_file(file)
puts "file.file_path = " + file.file_path.to_s
    end

    def added_line_to_file(line, file)
puts "added line = #{line.to_s} to file = #{file.file_path.to_s}"
    end
  end
end

parser = WcAck::Parser.new
parser.delegate = WcAck::WebConsoleBridge.new
files = parser.parse(ARGF.read)

# puts "files.inspect = " + files.inspect.to_s

# WcAck.load(ARGF.read)



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