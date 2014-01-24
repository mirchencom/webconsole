require 'webconsole'

module WcCoffee
  class Controller < WebConsole::Controller
    def parse_line(line)
      line = line.dup
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