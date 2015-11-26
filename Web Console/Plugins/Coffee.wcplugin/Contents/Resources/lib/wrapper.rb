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
      @input_controller ||= InputController.new(view)
    end

    def output_controller
      @output_controller ||= OutputController.new(view)
    end
    
    def view
      @view ||= View.new
    end

  end
end
