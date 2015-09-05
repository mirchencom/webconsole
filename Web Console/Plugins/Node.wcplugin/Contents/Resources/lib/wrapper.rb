require_relative '../bundle/bundler/setup'
require 'webconsole/repl'

module WebConsole::REPL::Node
  class Wrapper < WebConsole::REPL::Wrapper
    require_relative "output_controller"
    require_relative "view"

    def initialize
      super("node")
    end

    def parse_input(input)
      input.gsub!("\uFF00", "\n") # \uFF00 is the unicode character Coffee uses for new lines, it's used here just to consolidate code into one line
      input.gsub!(/^\s*$\n/, '') # Don't process blank lines
      super(input)
    end

    def write_input(input)
      input = input.dup
      input.gsub!("\t", "\s\s") # Replace tabs with spaces
      super(input)
    end

    def output_controller
      if !@output_controller
        @output_controller = OutputController.new
        @output_controller.view = view
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