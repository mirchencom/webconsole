#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require File.join(File.dirname(__FILE__), "lib", "wrapper")
require_relative "lib/dependencies"

passed = WebConsole::REPL::Node.check_dependencies
exit 1 unless passed

wrapper = WebConsole::REPL::Node::Wrapper.new

ARGF.each do |line|
  wrapper.parse_input(line)
end