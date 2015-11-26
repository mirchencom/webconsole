require_relative 'extension_constants'
require WEBCONSOLE_FILE

module WebConsole::REPL
  require_relative "repl/lib/input_controller"
  require_relative "repl/lib/output_controller"
  require_relative "repl/lib/view"

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
