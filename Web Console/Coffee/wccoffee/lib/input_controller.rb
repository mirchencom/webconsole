require 'webconsole'

module WcCoffee
  class InputController < WebConsole::Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "view")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize(delegate = nil)      
      super(delegate, VIEW_TEMPLATE)
    end

    def parse_input(input)
      input = input.dup
      input.gsub!("\uFF00", "\n")

      input.chomp!
      input.javascript_escape!
      if !input.strip.empty? # Ignore empty lines
        javascript = %Q[addInput('#{input}');]
        if @delegate
          @delegate.do_javascript(javascript)
        end
      end

    end

  end
end