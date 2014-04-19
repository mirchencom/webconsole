#!/usr/bin/env ruby

require "test/unit"
require_relative "../lib/checker"

class TestChecker < Test::Unit::TestCase

  def test_shell_command
    result = WcDependencies::Checker::check("grep", :shell_command)
    assert(result, "The dependency check should have succeeded.")
  end
  
  def test_missing_shell_command
    result = WcDependencies::Checker::check("asdf", :shell_command)
    assert(!result, "The dependency check should have failed.")
  end

end