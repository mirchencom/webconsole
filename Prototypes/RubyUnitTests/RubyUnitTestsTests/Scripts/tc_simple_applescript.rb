#!/usr/bin/env ruby

require "test/unit"

class TestSimpleAppleScript < Test::Unit::TestCase
  NUMBER = 10
  def test_simple_applescript
    result = `osascript -e "return #{NUMBER}"`
    result_int = result.to_i
    assert_equal(NUMBER, result_int, "Result doesn't match")
  end
end