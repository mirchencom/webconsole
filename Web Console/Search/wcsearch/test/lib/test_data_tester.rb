require "test/unit"

module TestHelper
  module TestDataTester
    def self.test_file_hashes(files_hash, test_files_hash)
      tested_at_least_one = false

      test_files_hash.keys.each do |file_path|
        tested_at_least_one = true

        test_file = test_files_hash[file_path]
        file = files_hash[file_path]
      
        if test_file.file_path != file.file_path
          puts "File path #{test_file.file_path} should match #{file.file_path}."
          return false
        end
          
        if test_file.display_file_path != file.display_file_path
          puts "Display file path #{test_file.display_file_path} should match #{file.display_file_path}."
          return false
        end

        test_file.lines.zip(file.lines).each do |test_line, line|

          if test_line.number != line.number
            puts "Line number #{test_line.number} should match #{line.number}."
            return false
          end

          if test_line.matches.count != line.matches.count
            puts "Match count #{test_line.matches.count} should match #{line.matches.count}."
            return false
          end

          test_line.matches.zip(line.matches).each do |test_match, match|
            if test_match.text != match.text
              puts "Match text #{test_match.text} should match #{match.text}."
              return false
            end
          end

        end

      end
      return tested_at_least_one

    end
  
  end
end