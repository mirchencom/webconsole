require_relative '../bundle/bundler/setup'
require 'webconsole/dependencies'

module WebConsole::Search
  def self.check_dependencies
    dependency_pwd = WebConsole::Dependencies::Dependency.new("pwd", :shell_command)
    dependency_grep = WebConsole::Dependencies::Dependency.new("grep", :shell_command)
    checker = WebConsole::Dependencies::Checker.new
    return checker.check_dependencies([dependency_grep, dependency_pwd])
  end
end