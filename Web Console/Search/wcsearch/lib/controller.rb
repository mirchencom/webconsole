require 'erb'
require 'cgi'

# Controller has a delegate, either domrunner or WebConsole
module WcSearch
  class Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    attr_writer :delegate
    def initialize(delegate = nil)
      @delegate = delegate

      view_erb = ERB.new(File.new(VIEW_TEMPLATE).read, nil, '-')
      html = view_erb.result
      if @delegate
        @delegate.load_html(html)
      end
    end

    def added_file(file)
      # Escape '
      file_path = file.file_path.gsub("'", "\\\\'")
      display_file_path = file.display_file_path.gsub("'", "\\\\'")
      javascript = "addFile('#{file_path}', '#{display_file_path}');"
      if @delegate
        @delegate.do_javascript(javascript)
      end
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
      text = CGI.escapeHTML(line.text)
      javascript = %Q[
var matches = [#{matches_javascript}  
];
addLine(#{line.number}, '#{text}', matches);
]
      if @delegate
        @delegate.do_javascript(javascript)
      end
    end
  end    
end