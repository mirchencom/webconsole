require_relative '../bundle/bundler/setup'
require 'webconsole'
require WebConsole::shared_resource("ruby/wcdependencies/wcdependencies")

module WcSearch
  def self.check_dependencies
    dependency_pwd = WcDependencies::Dependency.new("pwd", :shell_command)
    dependency_grep = WcDependencies::Dependency.new("grep", :shell_command)
    checker = WcDependencies::Checker.new
    return checker.check_dependencies([dependency_grep, dependency_pwd])
  end
end