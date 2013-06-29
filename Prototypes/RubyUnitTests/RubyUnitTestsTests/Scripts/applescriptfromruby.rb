#!/usr/bin/env ruby

require "test/unit"
require 'Shellwords'

SCRIPT_DIRECTORY = File.join(File.dirname(__FILE__))
DODIRECTPARAMETER_APPLESCRIPT_FILENAME = "DoDirectParameter.scpt"
DODIRECTPARAMETER_SCRIPT = File.join(SCRIPT_DIRECTORY, DODIRECTPARAMETER_APPLESCRIPT_FILENAME)

puts "#{Shellwords.escape(DODIRECTPARAMETER_SCRIPT)}"

class TestDoDirectParameter < Test::Unit::TestCase
  def test_test_data_generated
    result = `osascript #{Shellwords.escape(DODIRECTPARAMETER_SCRIPT)} "A string input"`
    puts result
  end
end