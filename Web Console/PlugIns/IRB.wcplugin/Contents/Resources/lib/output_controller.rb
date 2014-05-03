require_relative '../bundle/bundler/setup'
require 'webconsole/repl'

module WebConsole::REPL::IRB
  class OutputController < WebConsole::REPL::OutputController
    def parse_output(output)
      if output =~ /^irb\([^)]*\):[^:]*:[^>]*>/
        # Don't add echo of input
        return
      end

      output = output.dup
      output.sub!(/^=>\s/, "") # Remove output prompt
      super(output)
    end
  end
  
end