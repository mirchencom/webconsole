require File.join(File.dirname(__FILE__), "constants")
require CONTROLLER_FILE

module WcCoffee
  class OutputController < WcCoffee::Controller
    def initialize(delegate = nil)      
      @delegate = delegate
    end

    def parse_output(output)
      add_code(output)
    end
  end
end