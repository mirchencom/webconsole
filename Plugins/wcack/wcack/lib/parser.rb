MODEL_FILE = File.join(File.dirname(__FILE__), 'model')
require MODEL_FILE

module WcAck
  def self.load data
    parser = Parser.new
    parser.parse(data)
  end

  class Parser
    ANSI_ESCAPE = '\x1b[^m]*m'
    ANSI_ESCAPE_REGEXP = Regexp.new("#{ANSI_ESCAPE}")
    ANSI_WRAPPER_REGEXP = Regexp.new("#{ANSI_ESCAPE}" + '(.+?)' + "#{ANSI_ESCAPE}")
    METADATA_REGEXP = Regexp.new(ANSI_WRAPPER_REGEXP.source + ":#{ANSI_ESCAPE}[0-9]+#{ANSI_ESCAPE}:")

    def initialize
      @match_manager = MatchManager.new      
    end
    
    def parse(data)
      just_one = true
      data.each_line { |line|
        if just_one
          parse_line(line)
          just_one = false
        end
      }
    end

    private

    def parse_line(line)
puts "line = " + line.to_s


        ansi_wrapped = line.scan(ANSI_WRAPPER_REGEXP)
        text = line.sub(METADATA_REGEXP, '')

        index = 0
        while index && index < text.length
puts "index = " + index.to_s
puts "text = " + text.to_s


          matched_text = text[ANSI_WRAPPER_REGEXP]
puts "matched_text = " + matched_text.to_s
          matched_text = text.match(ANSI_WRAPPER_REGEXP)[1]
puts "matched_text = " + matched_text.to_s


          index = text.index(ANSI_WRAPPER_REGEXP)

          # index = text.index(ANSI_ESCAPE_REGEXP)
          text.sub!(ANSI_ESCAPE_REGEXP, '')

          




          # matched_text = text.pattern(ANSI_WRAPPER_REGEXP, offset)
          # index = text.index(ANSI_ESCAPE_REGEXP)
          # text.sub!(ANSI_WRAPPER_REGEXP, match)
          # length = matched_text.length

          # Find substring regular expression, remove it and store the match
                    
        end


# puts "raw_text = " + raw_text


# 1. Use regular expressions to find the beginning and end of each match
# 2. Remove the ANSI_ESCAPE codes as I iterate through and find them






        file_path = ansi_wrapped[0][0]
        file = @match_manager.file_with_file_path(file_path)

        line_number = ansi_wrapped[1][0].to_i        

# puts "ansi_wrapped = " + ansi_wrapped.to_s    
    end

    class MatchManager
      def initialize
        @files_hash = Hash.new
      end

      def file_with_file_path(file_path)
        file = @files_hash[file_path]
        if !file
          file = Match::File.new(file_path)
          @files_hash[file_path] = file
        end

        return file
      end
    end
  end
end
