require "yaml"

require "./lib/model"

module WcAck

  def self.import_yml(file)
    file_hash = YAML.load_file(file)
    files = Array.new
    file_hash.keys.each do |file_path|

      file = WcAck::Match::File.new(file_path)
      file_hash[file_path].each { |line_number, matches_hashes|

        line = WcAck::Match::File::Line.new(line_number)
        file.lines.push(line)

        matches_hashes.each { |match_hash|
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