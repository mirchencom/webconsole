#!/usr/bin/env ruby

require "test/unit"
require "yaml"

PARSER_FILE = File.join(File.dirname(__FILE__), '..', 'lib', 'parser')
require PARSER_FILE

TEST_DIRECTORY=File.join(File.dirname(__FILE__), 'data')
TEST_DATA_GENERATED=File.join(TEST_DIRECTORY, 'test_data_generated.yml')

class TestWCACK < Test::Unit::TestCase
  def test_test_data_generated
    test_data_hash = YAML.load_file(TEST_DATA_GENERATED)
    test_data = TestData.get_input_data(test_data_hash)
    test_files_hash = TestData.get_test_results(test_data_hash)

    files_hash = WcAck.load(test_data)

    test_files_hash.keys.each do |file_path|
      test_file = test_files_hash[file_path]
      file = files_hash[file_path]
      
      test_file.lines.zip(file.lines).each do |test_line, line|
        assert_equal(test_line.line_number, line.line_number, "Line numbers don't match.")
        assert_equal(test_line.matches.count, line.matches.count, "Match counts don't match")
        test_line.matches.zip(line.matches).each do |test_match, match|
          assert_equal(test_match.text, match.text, "Matched text doesn't match")
        end
      end
    end
  end 
end

# Helpers

class TestData
  INPUT_FILE_KEY = "input_file"
  RESULTS_KEY = "results"
  FILE_PATH_KEY = "file_path"
  LINE_NUMBER_KEY = "line_number"
  MATCHED_TEXT_KEY = "matched_text"

  def self.get_input_data(hash)
    input_file=File.join(TEST_DIRECTORY, hash[INPUT_FILE_KEY])
    `cat "#{input_file}"`
  end
  def self.get_test_results(test_data_hash)
    test_results_hashes = test_data_hash[RESULTS_KEY]
    test_files_hash = Hash.new
    test_lines_hash = Hash.new

    test_results_hashes.each { |test_results_hash|
      file_path = test_results_hash[FILE_PATH_KEY]
      line_number = test_results_hash[LINE_NUMBER_KEY]
      matched_text = test_results_hash[MATCHED_TEXT_KEY]

      test_file = test_files_hash[file_path]
      if !test_file
        test_file = TestFile.new(file_path)
        test_files_hash[file_path] = test_file
        # Create a new test_lines_hash, this will break if our test data isn't ordered
        test_lines_hash = Hash.new
      end

      test_line = test_lines_hash[line_number]
      if !test_line
        test_line = TestFile::TestLine.new(line_number)
        test_lines_hash[line_number] = test_line
        test_file.lines.push(test_line)
      end

      match = TestFile::TestLine::TestMatch.new(matched_text)
      test_line.matches.push(match)
    }

    return test_files_hash
  end

  class TestFile
    attr_reader :file_path, :lines
    def initialize(file_path)
      @file_path = file_path
      @lines = Array.new
    end
    class TestLine
      attr_reader :line_number, :matches
      def initialize(line_number)
        @line_number = line_number
        @matches = Array.new
      end
      class TestMatch
        attr_reader :text
        def initialize(text)
          @text = text
        end
      end
    end
  end
end
