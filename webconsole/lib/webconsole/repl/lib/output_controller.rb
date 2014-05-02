module WebConsole::REPL
  class OutputController < WebConsole::Controller

    attr_accessor :view
    def initialize
    end

    def parse_output(output)
      output = output.dup
      output.gsub!(/\x1b[^m]*m/, "") # Remove escape sequences
      output.chomp!
      output.javascript_escape!
      if !output.strip.empty? # Ignore empty lines
        javascript = %Q[WcREPL.addOutput('#{output}');]
        @view.do_javascript(javascript)
      end
    end

  end
end