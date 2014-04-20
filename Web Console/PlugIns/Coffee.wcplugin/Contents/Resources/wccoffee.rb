#!/usr/bin/env ruby

require 'webconsole'
require WebConsole::shared_resource("ruby/wcdependencies/wcdependencies")
require File.join(File.dirname(__FILE__), "lib", "wrapper")

installation_instructions = "With <a href=\"https://www.npmjs.org\">npm</a>, <code>npm install -g coffee-script</code>."
dependency = WcDependencies::Dependency.new("coffee", :shell_command, :installation_instructions => installation_instructions)
checker = WcDependencies::Checker.new
passed = checker.check(dependency)
if !passed
  exit 1
end

wrapper = WcCoffee::Wrapper.new

ARGF.each do |line|  
  wrapper.parse_input(line)
end