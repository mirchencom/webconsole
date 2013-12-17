require 'erb'

class String
  def escape_single_quote
    self.gsub("'", "\\\\'")
  end

  def escape_single_quote!
    replace(self.escape_single_quote)
  end
end

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
      file_path = file.file_path
      display_file_path = file.display_file_path
      file_path.escape_single_quote!
      display_file_path.escape_single_quote!
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
      text = line.text
      text.escape_single_quote!
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