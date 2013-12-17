require 'erb'

module WcPrint
  class Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "view")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    attr_writer :delegate
    def initialize(delegate)
      @delegate = delegate

      view_erb = ERB.new(File.new(VIEW_TEMPLATE).read, nil, '-')
      html = view_erb.result
      @delegate.load_html(html)
    end  
    def parse_line(line)
      line.chomp!
      line.javascript_escape!
      javascript = %Q[addOutput('#{line}');]
      @delegate.do_javascript(javascript)
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