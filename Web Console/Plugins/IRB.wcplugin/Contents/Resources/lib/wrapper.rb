require_relative '../bundle/bundler/setup'
require 'webconsole/repl'

module WebConsole::REPL::IRB
  class Wrapper < WebConsole::REPL::Wrapper
    require_relative "output_controller"
    require_relative "view"

    def initialize
      super("irb")
    end

    def parse_input(input)
      input.gsub!("\uFF00", "\n") # \uFF00 is the unicode character Coffee uses for new lines, it's used here just to consolidate code into one line
      super(input)
    end

    def output_controller
      @output_controller ||= OutputController.new(view)
    end
    
    def view
      @view ||= View.new
    end

  end  
end
