require_relative '../bundle/bundler/setup'
require 'webconsole'
require WebConsole::shared_resource("ruby/wcdependencies/wcdependencies")

module WcNode
  def self.check_dependencies
    installation_instructions = "With <a href=\"http://brew.sh\">Homebrew</a>, <code>brew install node</code>."
    dependency = WcDependencies::Dependency.new("node", :shell_command, :installation_instructions => installation_instructions)
    checker = WcDependencies::Checker.new
    return checker.check(dependency)
  end
end