#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require 'Shellwords'

require_relative "bundle/bundler/setup"
require "webconsole"

require_relative "lib/dependencies"
require_relative "lib/constants"
require_relative "lib/parser"
require_relative "lib/controller"

passed = WebConsole::Search.check_dependencies
exit 1 unless passed

# Parser
controller = WebConsole::Search::Controller.new

directory = ARGV[1].dup if ARGV[1]
directory = `pwd` unless directory

parser = WebConsole::Search::Parser.new(controller, directory)

# Parse
term = ARGV[0]
directory.chomp!

exit 1 unless term && directory

command = "#{SEARCH_COMMAND} #{Shellwords.escape(term)} #{Shellwords.escape(directory)}"
pipe = IO.popen(command)
while (line = pipe.gets)
  parser.parse_line(line)
end