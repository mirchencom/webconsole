require 'Shellwords'

TEST_DATA_HELPER_DIRECTORY = File.dirname(__FILE__)
TEST_SCRIPT_CONSTANTS_FILE = File.join(TEST_DATA_HELPER_DIRECTORY, 'test_script_constants')
require TEST_SCRIPT_CONSTANTS_FILE # Get the TEST_DATA_DIRECTORY

module TestHelper

  module TestData
    TEST_SCRIPTS_DIRECTORY = File.join(TEST_DATA_HELPER_DIRECTORY, "..", "scripts")

    def self.test_data_directory
      return TEST_DATA_DIRECTORY
    end

    def self.test_search_term
      return SEARCH_TERM
    end

    OUTPUT_DIRECTORY = File.join(TEST_SCRIPTS_DIRECTORY, "output")
    TEST_ACK_OUTPUT_OUTPUT_FILE = File.join(OUTPUT_DIRECTORY, "test_ack_output")
    def self.test_ack_output
      command = "cat #{Shellwords.escape(TEST_ACK_OUTPUT_OUTPUT_FILE)}"
      result = `#{command}`
      return result
    end
    TEST_DATA_JSON_OUTPUT_FILE = File.join(OUTPUT_DIRECTORY, "test_data_json.json")
    def self.test_data_json
      command = "cat #{Shellwords.escape(TEST_DATA_JSON_OUTPUT_FILE)}"
      result = `#{command}`
      return result
    end
    # TODO Above is a quick hack replace of below because below wouldn't run in TextMate's run command window
    # TEST_ACK_OUTPUT_FILE = File.join(TEST_SCRIPTS_DIRECTORY, "test_ack_output.rb")    
    # def self.test_ack_output
    #   command = Shellwords.escape(TEST_ACK_OUTPUT_FILE)
    #   result = `#{command}`
    #   return result
    # end  
    # TEST_DATA_JSON_FILE = File.join(TEST_SCRIPTS_DIRECTORY, "test_data_json.rb")
    # def self.test_data_json
    #   command = Shellwords.escape(TEST_DATA_JSON_FILE)
    #   result = `#{command}`
    #   return result
    # end
  end

end