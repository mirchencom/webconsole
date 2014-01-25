#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "..", "repl_wrapper")

wrapper = WcREPLWrapper::REPLWrapper.new("coffee")

ARGF.each do |line|
  wrapper.parse_input(line)
end