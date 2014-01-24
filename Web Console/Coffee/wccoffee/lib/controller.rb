require 'webconsole'

module WcCoffee
  class Controller < WebConsole::Controller
    def add_code(code)
      code.chomp!
      code.javascript_escape!
      if !code.strip.empty? # Ignore empty lines
        javascript = %Q[addCode('#{code}');]
        if @delegate
          @delegate.do_javascript(javascript)
        end
      end
    end
  end
end