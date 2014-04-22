require_relative '../bundle/bundler/setup'
require 'webconsole'
require WebConsole::shared_resource("ruby/wcdependencies/wcdependencies")

module WcCoffee
  def self.check_dependencies
    installation_instructions = "With <a href=\"https://www.npmjs.org\">npm</a>, <code>npm install -g coffee-script</code>."
    dependency = WcDependencies::Dependency.new("coffee", :shell_command, :installation_instructions => installation_instructions)
    checker = WcDependencies::Checker.new
    return checker.check(dependency)
  end
end