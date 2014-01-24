require File.join(File.dirname(__FILE__), "constants")
require CONTROLLER_FILE

module WcCoffee
  class BridgeController < WcCoffee::Controller
    def initialize(delegate = nil)      
      @delegate = delegate
    end
  end
end