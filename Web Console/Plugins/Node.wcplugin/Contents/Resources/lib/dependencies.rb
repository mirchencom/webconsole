require_relative '../bundle/bundler/setup'
require 'webconsole/dependencies'
require 'webconsole/repl'

module WebConsole::REPL::Node
  def self.check_dependencies
    installation_instructions = "With <a href=\"http://brew.sh\">Homebrew</a>, <code>brew install node</code>."
    dependency = WebConsole::Dependencies::Dependency.new("node", :shell_command, :installation_instructions => installation_instructions)
    checker = WebConsole::Dependencies::Checker.new
    return checker.check(dependency)
  end
end