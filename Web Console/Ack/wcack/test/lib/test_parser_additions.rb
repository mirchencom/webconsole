TEST_PARSER_ADDITIONS_DIRECTORY = File.dirname(__FILE__)
require File.join(TEST_PARSER_ADDITIONS_DIRECTORY, 'test_constants')
require PARSER_FILE

module WcAck
  class Parser
    attr_reader :files_hash
    def parse(data)
      data.each_line { |line|
          parse_line(line)
      }
    end
  end
end