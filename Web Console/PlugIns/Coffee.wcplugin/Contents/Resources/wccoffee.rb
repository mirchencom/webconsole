#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require File.join(File.dirname(__FILE__), "lib", "wrapper")
require_relative "lib/dependencies"

passed = WcCoffee.check_dependencies
if !passed
  exit 1
end

wrapper = WcCoffee::Wrapper.new

ARGF.each do |line|  
  wrapper.parse_input(line)
end