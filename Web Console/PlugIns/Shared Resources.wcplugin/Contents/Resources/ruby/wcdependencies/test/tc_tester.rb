#!/usr/bin/env ruby

require "test/unit"
require_relative "../lib/tester"

class TestTester < Test::Unit::TestCase

  def test_shell_command
    result = WcDependencies::Tester::check("grep", :shell_command)
    assert(result, "The dependency check should have succeeded.")
  end
  
  def test_missing_shell_command
    result = WcDependencies::Tester::check("asdf", :shell_command)
    assert(!result, "The dependency check should have failed.")
  end

end