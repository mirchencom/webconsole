require 'webconsole'

module WcCoffee
  class OutputController < WebConsole::Controller
    def initialize(delegate = nil)      
      @delegate = delegate
    end

    def parse_output(output)
      output.sub!(/^coffee\>\s/, "")
      output.chomp!
      output.javascript_escape!
      if !output.strip.empty? # Ignore empty lines
        javascript = %Q[addOutput('#{output}');]
        if @delegate
          @delegate.do_javascript(javascript)
        end
      end
    end
  end
end