require 'erb'

module WcIRB
  class Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "view")
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
    def parse_line(line)
      line.chomp!
      javascript = %Q[addOutput('#{line.gsub("'", "\\\\'")}');]
      if @delegate
        @delegate.do_javascript(javascript)
      end
    end
  end
end