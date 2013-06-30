#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'

SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))

class TestDoDirectParameter < Test::Unit::TestCase
  DODIRECTPARAMETER_APPLESCRIPT_FILENAME = "DoDirectParameter.scpt"
  DODIRECTPARAMETER_SCRIPT = File.join(SCRIPT_DIRECTORY, DODIRECTPARAMETER_APPLESCRIPT_FILENAME)

  def test_dodirectparamter
    test_string = "A string input"

    puts "script = #{Shellwords.escape(DODIRECTPARAMETER_SCRIPT)}"

    result = `osascript #{Shellwords.escape(DODIRECTPARAMETER_SCRIPT)} #{Shellwords.escape(test_string)}`
    result.strip_applescript!

    assert_equal(test_string, result, "Test string doesn't match result")
  end
end

class String
  def strip_applescript
    newString = self.strip
    newString.slice!(0)
    newString.chomp!('\'')
    newString
  end
  def strip_applescript!
    replace(self.strip_applescript)
  end
end