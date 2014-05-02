module WebConsole::REPL
  class InputController < WebConsole::Controller

    attr_accessor :view
    def initialize
    end

    def parse_input(input)
      input = input.dup
      input.chomp!
      input.javascript_escape!
      if !input.strip.empty? # Ignore empty lines
        javascript = %Q[WcREPL.addInput('#{input}');]
        @view.do_javascript(javascript)
      end
    end

  end
end