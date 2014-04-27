require_relative '../bundle/bundler/setup'
require 'webconsole'
require WebConsole::shared_resource("ruby/wcrepl/wcrepl")

module WcNode
  class Wrapper < WcREPL::Wrapper
    require_relative "input_controller"
    require_relative "output_controller"
    require_relative "window_manager"

    def initialize
      super("node")
    end

    def parse_input(input)
      input.gsub!("\uFF00", "\n") # \uFF00 is the unicode character Coffee uses for new lines, it's used here just to consolidate code into one line
      super(input)
    end

    def write_input(input)
      input = input.dup
      input.gsub!("\t", "\s\s") # Replace tabs with spaces
      super(input)
    end

    def output_controller
      if !@output_controller
        @output_controller = OutputController.new(window_manager)
      end
      return @output_controller
    end

    def input_controller
      if !@input_controller
        @input_controller = InputController.new(window_manager)
      end
      return @input_controller
    end

    def window_manager
      if !@window_manager
        @window_manager = WindowManager.new
      end
      return @window_manager
    end    
  end
  
end