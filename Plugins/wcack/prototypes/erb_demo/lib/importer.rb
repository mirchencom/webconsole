require "yaml"

require File.join(File.dirname(__FILE__), 'model')

module WcAck

  def self.import_yml(file)
    file_hash = YAML.load_file(file)

    files = Array.new
    file_hash.each do |file_path, line_hashes|

      file = WcAck::Match::File.new(file_path)
      
      line_hashes.each { |line_number, line_hash|

        line = WcAck::Match::File::Line.new(line_number, line_hash["text"])
        file.lines.push(line)

        line_hash["matches"].each { |match_hash|
          match = WcAck::Match::File::Line::Match.new(match_hash["start"], match_hash["length"])
          line.matches.push(match)
        }

      }

      files.push(file)
    end

    files
  end

  def self.dump_files(files)
    files.each { |file|
      puts "file.path = " + file.path.to_s
      file.lines.each { |line| 
        puts "\tline.line_number = " + line.line_number.to_s
        line.matches.each { |match|
          puts "\t\tmatch.start = " + match.start.to_s
          puts "\t\tmatch.length = " + match.length.to_s
        }
      }  
    }  
  end

end