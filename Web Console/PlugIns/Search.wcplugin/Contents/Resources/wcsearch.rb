#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require 'Shellwords'
require_relative "lib/dependencies"

LIB_DIRECTORY = File.join(File.dirname(__FILE__), "lib")

CONSTANTS_FILE = File.join(LIB_DIRECTORY, "constants")
require CONSTANTS_FILE

PARSER_FILE = File.join(LIB_DIRECTORY, "parser")
require PARSER_FILE

CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE

WINDOW_MANAGER_FILE = File.join(LIB_DIRECTORY, "window_manager")
require WINDOW_MANAGER_FILE

passed = WcSearch.check_dependencies
if !passed
  exit 1
end

# Window Manager
window_manager = WcSearch::WindowManager.new

# Parser
controller = WcSearch::Controller.new(window_manager)

if ARGV[1]
  directory = ARGV[1].dup
end
if !directory
  directory = `pwd`
end

parser = WcSearch::Parser.new(controller, directory)

# Parse
term = ARGV[0]
directory.chomp!

command = "#{SEARCH_COMMAND} #{Shellwords.escape(term)} #{Shellwords.escape(directory)}"
pipe = IO.popen(command)
while (line = pipe.gets)
  parser.parse_line(line)
end