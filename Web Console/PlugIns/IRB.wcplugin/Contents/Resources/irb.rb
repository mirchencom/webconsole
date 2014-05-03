#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require_relative "bundle/bundler/setup"
require "webconsole"

require_relative "lib/wrapper"

wrapper = WebConsole::IRB::Wrapper.new

ARGF.each do |line|
  wrapper.parse_input(line)
end