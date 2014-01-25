module WcREPLWrapper
  require File.join(File.dirname(__FILE__), "lib", "constants.rb")
  require INPUT_CONTROLLER_FILE
  require OUTPUT_CONTROLLER_FILE
  require WINDOW_MANAGER_FILE

  class REPLWrapper
    require 'pty'
    def initialize(command, input_controller_override = nil, output_controller_override = nil, window_manager_override = nil)
      @input_controller = input_controller_override
      @output_controller = output_controller_override
      @window_manager = window_manager_override

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
      @input.write(input)
    end

    private

    def input_controller
      if !@input_controller
        @input_controller = WcREPLWrapper::InputController.new(window_manager)
      end
      return @input_controller
    end
    
    def output_controller
      if !@output_controller
        @output_controller = WcREPLWrapper::OutputController.new(window_manager)
      end
      return @output_controller
    end
    
    def window_manager
      if !@window_manager
        @window_manager = WcREPLWrapper::WindowManager.new
      end
      return @window_manager
    end

  end
end