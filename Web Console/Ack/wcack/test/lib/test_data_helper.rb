require 'Shellwords'

TEST_DATA_HELPER_DIRECTORY = File.expand_path(File.dirname(__FILE__))
TEST_SCRIPTS_DIRECTORY = File.join(TEST_DATA_HELPER_DIRECTORY, "..", "scripts")

module TestHelper

  module TestData
    TEST_ACK_OUTPUT_FILE = File.join(TEST_SCRIPTS_DIRECTORY, "test_ack_output.rb")
    def self.test_ack_output
      command = Shellwords.escape(TEST_ACK_OUTPUT_FILE)
      result = `#{command}`
      return result
    end

    TEST_DATA_JSON_FILE = File.join(TEST_SCRIPTS_DIRECTORY, "test_data_json.rb")
    def self.test_data_json
      command = Shellwords.escape(TEST_DATA_JSON_FILE)
      result = `#{command}`
      return result
    end
  end

end