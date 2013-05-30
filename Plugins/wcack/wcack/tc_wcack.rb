require "test/unit"
require "yaml"

require File.join(File.dirname(__FILE__), 'lib', 'parser')

TEST_DIRECTORY=File.join(File.dirname(__FILE__), 'support', 'tests', 'data')
TEST_DATA_GENERATED=File.join(TEST_DIRECTORY, 'test_data_generated.yml')
TEST_DATA=File.join(TEST_DIRECTORY, 'test_data.yml')


class TestWCACK < Test::Unit::TestCase
  def test_test_data_generated
    test_file_hash = YAML.load_file(TEST_DATA_GENERATED)
    test_data = TestDataFactory.test_data_from_test_file_hash(test_file_hash)
    test_result = TestDataFactory.test_result_from_test_file_hash(test_file_hash)

    match = Match.new(test_data.line)

    assert_equal(match.file_path, test_result.filename, "File path doesn't match.")
    assert_equal(match.line_number, test_result.line_number, "Line number doesn't match.")
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
  attr_reader :line_number, :filename, :match
  def initialize(test_results)
    @line_number = test_results["linenumber"]
    @filename = test_results["filename"]
    @match = test_results["match"]
  end
end