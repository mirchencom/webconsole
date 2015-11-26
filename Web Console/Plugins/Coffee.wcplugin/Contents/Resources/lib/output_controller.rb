require_relative '../bundle/bundler/setup'
require 'webconsole/repl'

module WebConsole::REPL::Coffee
  class OutputController < WebConsole::REPL::OutputController

    def parse_output(output)
      return if output =~ /^\x1b[^coffee>]*coffee>/ # Don't add echo of input
      super(output)
    end

  end  
end