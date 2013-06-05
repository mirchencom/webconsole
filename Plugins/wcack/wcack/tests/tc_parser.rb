require "test/unit"
require "yaml"

PARSER_FILE = File.join(File.dirname(__FILE__), '..', 'lib', 'parser')
require PARSER_FILE

TEST_DIRECTORY=File.join(File.dirname(__FILE__), 'data')
TEST_DATA_GENERATED=File.join(TEST_DIRECTORY, 'test_data_generated.yml')

class TestWCACK < Test::Unit::TestCase
  def test_test_data_generated
    test_file_hash = YAML.load_file(TEST_DATA_GENERATED)
    
    # test_results = 

    test_data = TestDataFactory.get_input_data(test_file_hash)

    test_results = TestDataFactory.test_result_from_test_file_hash(test_file_hash)

    # WcACK.load()

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
  def self.test_result_from_test_file_hash(test_file_hash)
    TestResult.new(test_file_hash[RESULTS_KEY])
  end
end

class TestResult
  attr_reader :line_number, :file_path, :match
  def initialize(test_results)
    @file_path = test_results["file_path"]
    @filename = test_results["filename"]
    @match = test_results["match"]
  end
end
