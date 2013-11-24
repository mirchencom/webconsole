TEST_PARSER_ADDITIONS_DIRECTORY = File.expand_path(File.dirname(__FILE__))
require File.join(TEST_PARSER_ADDITIONS_DIRECTORY, 'test_constants')
require PARSER_FILE

module WcAck
  class Parser

    def self.load(data) 
      parser = Parser.new
      parser.parse(data)
    end

    def parse(data)
      data.each_line { |line|
          parse_line(line)
      }
      return @files_hash
    end

  end
end