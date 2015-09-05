require_relative '../bundle/bundler/setup'
require 'webconsole/dependencies'
require 'webconsole/repl'

module WebConsole::REPL::Coffee
  def self.check_dependencies
    installation_instructions = "With <a href=\"https://www.npmjs.org\">npm</a>, <code>npm install -g coffee-script</code>."
    dependency = WebConsole::Dependencies::Dependency.new("coffee", :shell_command, :installation_instructions => installation_instructions)
    checker = WebConsole::Dependencies::Checker.new
    return checker.check(dependency)
  end
end