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
    LINE_ENDING_REGEXP = Regexp.new("#{ANSI_ESCAPE}" + '\x1b\[K')

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

          index = text.index(ANSI_WRAPPER_REGEXP)
          if index
            matched_text = text.match(ANSI_WRAPPER_REGEXP)[1]
            text.sub!(ANSI_WRAPPER_REGEXP, matched_text)
            puts "matched_text.length = " + matched_text.length.to_s
          end                 
        end
        text.sub!(LINE_ENDING_REGEXP, '') 
        text.rstrip!






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
