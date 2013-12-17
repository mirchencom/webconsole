require 'erb'

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
      file_path.javascript_escape!
      display_file_path.javascript_escape!
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
      text.javascript_escape!
      javascript = %Q[
var matches = [#{matches_javascript}  
];
addLine(#{line.number}, '#{text}', matches);
]
      if @delegate
        @delegate.do_javascript(javascript)
      end
    end

    private

    class ::String
      def javascript_escape
        self.gsub('\\', "\\\\\\\\").gsub("'", "\\\\'")
      end

      def javascript_escape!
        replace(self.javascript_escape)
      end
    end
    
  end
end