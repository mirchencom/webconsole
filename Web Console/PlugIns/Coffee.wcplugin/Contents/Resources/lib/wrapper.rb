require_relative '../bundle/bundler/setup'
require 'webconsole'
require WebConsole::shared_resource("ruby/wcrepl/wcrepl")

module WcCoffee
  class Wrapper < WcREPL::Wrapper
    require_relative "output_controller"
    require_relative "input_controller"
    require_relative "window_manager"

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
        @input_controller = InputController.new(window_manager)
      end
      return @input_controller
    end

    def output_controller
      if !@output_controller
        @output_controller = OutputController.new(window_manager)
      end
      return @output_controller
    end
    
    def window_manager
      if !@window_manager
        @window_manager = WindowManager.new
      end
      return @window_manager
    end    
  end
  
end