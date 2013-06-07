require "test/unit"
require "yaml"

PARSER_FILE = File.join(File.dirname(__FILE__), '..', 'lib', 'parser')
require PARSER_FILE

TEST_DIRECTORY=File.join(File.dirname(__FILE__), 'data')
TEST_DATA_GENERATED=File.join(TEST_DIRECTORY, 'test_data_generated.yml')

class TestWCACK < Test::Unit::TestCase
  def test_test_data_generated
    test_file_hash = YAML.load_file(TEST_DATA_GENERATED)
    test_data = TestDataFactory.get_input_data(test_file_hash)
    test_results = TestDataFactory.get_test_results(test_file_hash)

#     test_results.each { |test_result|
# puts "test_result.file_path = " + test_result.file_path.to_s
# puts "test_result.line_number = " + test_result.line_number.to_s
# puts "test_result.matched_text = " + test_result.matched_text.to_s
#     }

    files_hash = WcAck.load(test_data)

    puts files_hash

    # parse_line = ParsedLine.new(test_data.line)

    # assert_equal(parse_line.file_path, test_result.filename, "File path doesn't match.")
    # assert_equal(parse_line.line_number, test_result.line_number, "Line number doesn't match.")
  end 
end

# Helpers

INPUT_FILE_KEY = "input_file"
RESULTS_KEY = "results"
class TestDataFactory
  def self.get_input_data(hash)
    input_file=File.join(TEST_DIRECTORY, hash[INPUT_FILE_KEY])
    `cat "#{input_file}"`
  end
  def self.get_test_results(test_file_hash)
    test_results_hashes = test_file_hash[RESULTS_KEY]
    Array.new(test_results_hashes.count) { |i|
      TestResult.new(test_results_hashes[i])
    }    
  end
end

class TestResult
  attr_reader  :file_path, :line_number, :matched_text
  def initialize(test_results_hash)
    @file_path = test_results_hash["file_path"]
    @line_number = test_results_hash["line_number"]
    @matched_text = test_results_hash["matched_text"]
  end
end