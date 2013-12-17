require 'erb'

class String
  def escape_single_quote
    self.gsub("'", "\\\\'")
  end

  def escape_single_quote!
    replace(self.escape_single_quote)
  end
end

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
      line.escape_single_quote!
      if !line.strip.empty? # Ignore empty lines
        javascript = %Q[addOutput('#{line}');]
        if @delegate
          @delegate.do_javascript(javascript)
        end
      end
    end
  end
end