MODEL_FILE = File.join(File.dirname(__FILE__), 'model')
require MODEL_FILE

module WcAck
  def self.load(data) 
    parser = Parser.new
    parser.parse(data)
  end

  class Parser
    ANSI_ESCAPE = '\x1b[^m]*m'
    ANSI_ESCAPE_REGEXP = Regexp.new("#{ANSI_ESCAPE}")
    ANSI_WRAPPER_REGEXP = Regexp.new("#{ANSI_ESCAPE}" + '(.+?)' + "#{ANSI_ESCAPE}")
    METADATA_REGEXP = Regexp.new(ANSI_WRAPPER_REGEXP.source + ":#{ANSI_ESCAPE}[0-9]+#{ANSI_ESCAPE}:")
    LINE_ENDING_REGEXP = Regexp.new("#{ANSI_ESCAPE}" + '\x1b\[K')

    attr_writer :delegate
    def initialize
      @files_hash = Hash.new
    end
    
    def parse(data)
      data.each_line { |line|
          parse_line(line)
      }
      return @files_hash
    end

    private

    def parse_line(raw_line)
      ansi_wrapped = raw_line.scan(ANSI_WRAPPER_REGEXP)

      file_path = ansi_wrapped[0][0]
      file = @files_hash[file_path]
      if !file
        file = Match::File.new(file_path)
        @files_hash[file_path] = file

        @delegate.added_file(file)
      end

      line_number = ansi_wrapped[1][0].to_i
      line = Match::File::Line.new(line_number)
      file.lines.push(line)

      text = raw_line.sub(METADATA_REGEXP, '')
      index = 0
      while index && index < text.length
        index = text.index(ANSI_WRAPPER_REGEXP)
        if index
          matched_text = text.match(ANSI_WRAPPER_REGEXP)[1]
          text.sub!(ANSI_WRAPPER_REGEXP, matched_text)
          length = matched_text.length

          match = Match::File::Line::Match.new(index, length, line)

          line.matches.push(match)
        end                 
      end
      text.sub!(LINE_ENDING_REGEXP, '') 
      text.rstrip!

      line.text = text

      @delegate.added_line_to_file(line, file)
    end
  end
end
