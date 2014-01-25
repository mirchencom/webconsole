#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "..", "wcrepl")

wrapper = WcREPL::Wrapper.new("coffee")

ARGF.each do |line|
  wrapper.parse_input(line)
end