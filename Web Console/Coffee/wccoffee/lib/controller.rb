require 'webconsole'

module WcCoffee
  class Controller < WebConsole::Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "view")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize(delegate = nil)      
      super(delegate, VIEW_TEMPLATE)
    end

    def parse_line(line)
      line.chomp!
      line.javascript_escape!
      if !line.strip.empty? # Ignore empty lines
        javascript = %Q[addOutput('#{line}');]
        if @delegate
          @delegate.do_javascript(javascript)
        end
      end
    end

  end
end