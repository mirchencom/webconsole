require 'webconsole'
require WebConsole::shared_resource("ruby/repl_wrapper/repl_wrapper")
require File.join(File.dirname(__FILE__), "constants")

module WcIRB
  class Wrapper < WcREPLWrapper::REPLWrapper
    require OUTPUT_CONTROLLER_FILE
    require INPUT_CONTROLLER_FILE
    require WINDOW_MANAGER_FILE

    def input_controller
      if !@input_controller
        @input_controller = WcIRB::InputController.new(window_manager)
      end
      return @input_controller
    end

    def output_controller
      if !@output_controller
        @output_controller = WcIRB::OutputController.new(window_manager)
      end
      return @output_controller
    end
    
    def window_manager
      if !@window_manager
        @window_manager = WcIRB::WindowManager.new
      end
      return @window_manager
    end    
  end
  
end