#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require 'Shellwords'

require_relative "lib/dependencies"
require_relative "lib/constants"
require_relative "lib/parser"
require_relative "lib/controller"
require_relative "lib/window_manager"

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