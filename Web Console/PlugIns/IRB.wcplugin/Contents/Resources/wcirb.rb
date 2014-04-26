#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require File.join(File.dirname(__FILE__), "lib", "wrapper")

wrapper = WcIRB::Wrapper.new

ARGF.each do |line|
  wrapper.parse_input(line)
end