require "test/unit"
require "yaml"

PARSER_FILE = File.join(File.dirname(__FILE__), '..', 'lib', 'parser')
puts PARSER_FILE
require PARSER_FILE

TEST_DIRECTORY=File.join(File.dirname(__FILE__), 'data')
TEST_DATA_GENERATED=File.join(TEST_DIRECTORY, 'test_data_generated.yml')
TEST_DATA=File.join(TEST_DIRECTORY, 'test_data.yml')

class TestWCACK < Test::Unit::TestCase
  def test_test_data_generated
    test_file_hash = YAML.load_file(TEST_DATA_GENERATED)
    test_data = TestDataFactory.test_data_from_test_file_hash(test_file_hash)
    test_result = TestDataFactory.test_result_from_test_file_hash(test_file_hash)

    parse_line = ParsedLine.new(test_data.line)

    assert_equal(parse_line.file_path, test_result.filename, "File path doesn't match.")
    assert_equal(parse_line.line_number, test_result.line_number, "Line number doesn't match.")
  end 
end

# Helpers

class TestDataFactory
  def self.test_data_from_test_file_hash(test_file_hash)
    TestData.new(test_file_hash["test"])
  end
  def self.test_result_from_test_file_hash(test_file_hash)
    TestResult.new(test_file_hash["result"])
  end
end

class TestData
  attr_reader :term, :line
  def initialize(test_data)
    line_output_file=File.join(TEST_DIRECTORY, test_data["lineoutputfile"])
    @line = `cat "#{line_output_file}"`
    @term = test_data["term"]
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
