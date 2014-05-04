require_relative '../bundle/bundler/setup'
require 'webconsole/repl'

module WebConsole::REPL::Node
  class OutputController < WebConsole::REPL::OutputController

    def parse_output(output)
      if output =~ /\x1b[^G]*G\x1b[^J]*J\>\s\x1b[^G]*G/
        # Don't add echo of input
        return
      end
      super(output)
    end

  end
end