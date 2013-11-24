#!/usr/bin/env ruby

require "test/unit"

TEST_DIRECTORY = File.expand_path(File.dirname(__FILE__))
TEST_HELPER_FILE = File.join(TEST_DIRECTORY, "test_helper")
require TEST_HELPER_FILE

PARSER_FILE = File.join(File.dirname(__FILE__), '..', 'lib', 'parser')
require PARSER_FILE

class TestParser < Test::Unit::TestCase

  def test_parser
    test_helper = TestHelper.new
    test_data = test_helper.test_data
    test_files_hash = test_helper.test_files_hash

    files_hash = WcAck.load(test_data)

    test_files_hash.keys.each do |file_path|
      test_file = test_files_hash[file_path]
      file = files_hash[file_path]
      
      test_file.lines.zip(file.lines).each do |test_line, line|
        assert_equal(test_line.number, line.number, "Line numbers don't match.")
        assert_equal(test_line.matches.count, line.matches.count, "Match counts don't match")
        test_line.matches.zip(line.matches).each do |test_match, match|
          assert_equal(test_match.text, match.text, "Matched text doesn't match")
        end
      end
    end
  end

end

