require_relative '../bundle/bundler/setup'
require 'webconsole/repl'

module WebConsole::REPL::IRB
  class OutputController < WebConsole::REPL::OutputController
    def initialize(view)
      super(view)
      @SEEN_PROMPT = false
    end

    def parse_output(output)

      # Quick hack to fix a bug where on first run IRB is echoing the input twice
      # if !@SEEN_PROMPT && output =~ /^=>\s/
      #   @SEEN_PROMPT = true
      # else
      #   return
      # end

      if output =~ /^irb\([^)]*\):[^:]*:[^>]*(>|\*)/
        # Don't add echo of input
        return
      end

      output = output.dup
      output.sub!(/^=>\s/, "") # Remove output prompt
      super(output)
    end
  end
  
end
