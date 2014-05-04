require_relative '../bundle/bundler/setup'
require 'webconsole/repl'

module WebConsole::REPL::Coffee
  class InputController < WebConsole::REPL::InputController
    
    def parse_input(input)
      input = input.dup
      input.gsub!("\uFF00", "\n")
      super(input)
    end

  end
end