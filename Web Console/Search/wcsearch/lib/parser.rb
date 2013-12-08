MODEL_FILE = File.join(File.dirname(__FILE__), 'model')
require MODEL_FILE

require 'pathname'

module WcSearch

  class Parser
    ANSI_ESCAPE = '\x1b[^m]*m'
    MATCH_REGEXP = Regexp.new("#{ANSI_ESCAPE}(.+?)#{ANSI_ESCAPE}")
    METADATA_REGEXP = Regexp.new((MATCH_REGEXP.source) + ":#{ANSI_ESCAPE}([0-9]+)#{ANSI_ESCAPE}:")
    LINE_ENDING = "#{ANSI_ESCAPE}" + '\x1b\[K'
    TEXT_REGEXP = Regexp.new("#{ANSI_ESCAPE}.+?#{ANSI_ESCAPE}:#{ANSI_ESCAPE}[0-9]+#{ANSI_ESCAPE}:(.*?)#{LINE_ENDING}")

    attr_writer :delegate
    def initialize(delegate = nil, directory = nil)
      @delegate = delegate
      @directory = directory
      @files_hash = Hash.new
    end
   
    def parse_line(output_line)

      metadata_captures = output_line.match(METADATA_REGEXP).captures
      file_path = metadata_captures[0]
      file_path = File.expand_path(file_path) # Convert paths with .. to full paths
      if @directory
        display_file_path = Pathname.new(file_path).relative_path_from(Pathname.new(@directory)).to_s
      end

      file = @files_hash[file_path]
      if !file
        file = Match::File.new(file_path, display_file_path)
        @files_hash[file_path] = file

        if @delegate 
          @delegate.added_file(file)
        end
      end

      line_number = metadata_captures[1].to_i
      line = Match::File::Line.new(line_number)
      file.lines.push(line)

      text = output_line.match(TEXT_REGEXP).captures[0]
      index = 0
      while index && index < text.length
        index = text.index(MATCH_REGEXP)
        if index
          matched_text = text.match(MATCH_REGEXP)[1]
          text.sub!(MATCH_REGEXP, matched_text)
          length = matched_text.length

          match = Match::File::Line::Match.new(index, length, line)

          line.matches.push(match)
        end                 
      end
      text.rstrip!

      line.text = text
      
      if @delegate
        @delegate.added_line_to_file(line, file)
      end
    end
  end
end
