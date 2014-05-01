module WcREPL
  require_relative "lib/input_controller"
  require_relative "lib/output_controller"
  require_relative "lib/window_manager"

  class Wrapper
    require 'pty'
    def initialize(command)

      PTY.spawn(command) do |output, input, pid|
        Thread.new do
          output.each { |line|
            output_controller.parse_output(line)
          }
        end
        @input = input
      end
    end

    def parse_input(input)
      input_controller.parse_input(input)
      write_input(input)
    end

    def write_input(input)
      @input.write(input)
    end

    private

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