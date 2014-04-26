require_relative "../../lib/parser"

module WcSearch
  class Parser
    attr_reader :files_hash
    def parse(data)
      data.each_line { |line|
          parse_line(line)
      }
    end
  end
end