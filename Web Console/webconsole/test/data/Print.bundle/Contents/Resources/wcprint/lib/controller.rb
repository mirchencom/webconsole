require 'erb'

class String
  def escape_single_quote
    self.gsub("'", "\\\\'")
  end

  def escape_single_quote!
    replace(self.escape_single_quote)
  end
end

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
      line.escape_single_quote!
      javascript = %Q[addOutput('#{line}');]
      @delegate.do_javascript(javascript)
    end
  end
end