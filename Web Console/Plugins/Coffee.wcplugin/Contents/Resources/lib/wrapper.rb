require_relative '../bundle/bundler/setup'
require 'webconsole/repl'

module WebConsole::REPL::Coffee

  class Wrapper < WebConsole::REPL::Wrapper
    require_relative "output_controller"
    require_relative "input_controller"
    require_relative "view"

    def initialize
      super("coffee")
    end

    def write_input(input)
      input = input.dup
      input.gsub!("\t", "\s\s\s\s") # Coffee in pty handles spaces better than tabs
      super(input)
    end

    def input_controller
      if !@input_controller
        @input_controller = InputController.new(view)
      end
      return @input_controller
    end

    def output_controller
      if !@output_controller
        @output_controller = OutputController.new(view)
      end
      return @output_controller
    end
    
    def view
      if !@view
        @view = View.new
      end
      return @view
    end

  end
end
