#!/usr/bin/env ruby

require "test/unit"
require_relative "../lib/checker"

class TestChecker < Test::Unit::TestCase

  def setup
    @checker = WcDependencies::Checker.new
  end

  def test_shell_command
    @checker.check("grep", :shell_command)
  end


  def test_missing_shell_command
    @checker.check("asdf", :shell_command)
  end

end