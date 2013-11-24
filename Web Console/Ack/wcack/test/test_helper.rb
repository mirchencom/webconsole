require "yaml"
TEST_HELPER_DIRECTORY = File.expand_path(File.dirname(__FILE__))
DATA_DIRECTORY = File.join(TEST_HELPER_DIRECTORY, "data")

class TestHelper

  TEST_DATA_GENERATED = File.join(DATA_DIRECTORY, 'test_data_generated.yml')
  def initialize
    @test_data_hash = YAML.load_file(TEST_DATA_GENERATED)
  end

  def test_data
    @test_data ||= self.class.get_test_data(@test_data_hash)
  end

  def test_files_hash
    @test_files_hash ||= self.class.get_test_files_hash(@test_data_hash)
  end

  class TestFile
    attr_reader :file_path, :lines
    def initialize(file_path)
      @file_path = file_path
      @lines = Array.new
    end
    class TestLine
      attr_reader :number, :matches
      def initialize(number)
        @number = number
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

  private

  INPUT_FILE_KEY = "input_file"
  def self.get_test_data(hash)
    input_file = File.join(DATA_DIRECTORY, hash[INPUT_FILE_KEY])
    `cat "#{input_file}"`
  end

  RESULTS_KEY = "results"
  FILE_PATH_KEY = "file_path"
  LINE_NUMBER_KEY = "number"
  MATCHED_TEXT_KEY = "matched_text"
  def self.get_test_files_hash(hash)
    test_results_hashes = hash[RESULTS_KEY]
    test_files_hash = Hash.new
    test_lines_hash = Hash.new

    test_results_hashes.each { |test_results_hash|
      file_path = test_results_hash[FILE_PATH_KEY]
      number = test_results_hash[LINE_NUMBER_KEY]
      matched_text = test_results_hash[MATCHED_TEXT_KEY]

      test_file = test_files_hash[file_path]
      if !test_file
        test_file = TestFile.new(file_path)
        test_files_hash[file_path] = test_file
        # Create a new test_lines_hash, this will break if our test data isn't ordered
        test_lines_hash = Hash.new
      end

      test_line = test_lines_hash[number]
      if !test_line
        test_line = TestFile::TestLine.new(number)
        test_lines_hash[number] = test_line
        test_file.lines.push(test_line)
      end

      match = TestFile::TestLine::TestMatch.new(matched_text)
      test_line.matches.push(match)
    }

    return test_files_hash
  end

end
