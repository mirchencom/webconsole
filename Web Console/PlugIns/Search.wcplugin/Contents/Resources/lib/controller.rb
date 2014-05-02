require_relative 'view'
require_relative 'model'

module WebConsole::Search
  class Controller < WebConsole::Controller

    def initialize
      @view = View.new
    end

    def added_file(file)
      @view.add_file(file.file_path, file.display_file_path)
    end

    def added_line_to_file(line, file)
      matches_javascript = matches_javascript(line.matches)
      text = line.text
      text.javascript_escape!

      javascript = %Q[
#{matches_javascript}
addLine(#{line.number}, '#{text}', matches);
]
      @view.do_javascript(javascript)
    end

    private

    def matches_javascript(matches)
      matches_json = ""
      matches.each { |match|
        match_json = %Q[ 
  {
    index: #{match.index},
    length: #{match.length}
  },]
        matches_json << match_json
      }
      matches_json.chomp!(",");
      javascript = %Q[
var matches = [#{matches_json}  
];
]
      return javascript      
    end
  end
end