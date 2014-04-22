#!/usr/bin/env ruby

require_relative '../bundle/bundler/setup'
require 'webconsole'
require File.join(File.dirname(__FILE__), "lib", "wrapper")
require WebConsole::shared_resource("ruby/wcdependencies/wcdependencies")

installation_instructions = "With <a href=\"http://brew.sh\">Homebrew</a>, <code>brew install node</code>."
dependency = WcDependencies::Dependency.new("node", :shell_command, :installation_instructions => installation_instructions)
checker = WcDependencies::Checker.new
passed = checker.check(dependency)
if !passed
  exit 1
end

wrapper = WcNode::Wrapper.new

ARGF.each do |line|
  wrapper.parse_input(line)
end