#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require "test/unit"
require_relative "lib/test_constants"
require WEBCONSOLE_FILE

require_relative "../lib/tester"

class TestTester < Test::Unit::TestCase

  def test_shell_command
    result = WebConsole::Dependencies::Tester::check("grep", :shell_command)
    assert(result, "The dependency check should have succeeded.")
  end
  
  def test_missing_shell_command
    result = WebConsole::Dependencies::Tester::check("asdf", :shell_command)
    assert(!result, "The dependency check should have failed.")
  end

end