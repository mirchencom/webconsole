require_relative 'view'

module WebConsole::Search
  class Controller

    def initialize
      @view = View.new
    end

    def added_file(file)
      file_path = file.file_path
      display_file_path = file.display_file_path
      file_path.javascript_escape!
      display_file_path.javascript_escape!
      javascript = "addFile('#{file_path}', '#{display_file_path}');"

      @view.do_javascript(javascript)

    end

    def added_line_to_file(line, file)
      matches_javascript = ""
      line.matches.each { |match|
        match_javascript = %Q[ 
  {
    index: #{match.index},
    length: #{match.length}
  },]
        matches_javascript << match_javascript
      }
      matches_javascript.chomp!(",");
      text = line.text
      text.javascript_escape!
      javascript = %Q[
var matches = [#{matches_javascript}  
];
addLine(#{line.number}, '#{text}', matches);
]
      @view.do_javascript(javascript)

    end
    
  end
end