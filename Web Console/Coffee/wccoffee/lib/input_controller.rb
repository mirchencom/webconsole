require File.join(File.dirname(__FILE__), 'constants')
require CONTROLLER_FILE

module WcCoffee
  class InputController < WcCoffee::Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "view")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize(delegate = nil)      
      super(delegate, VIEW_TEMPLATE)
    end

    def parse_input(input)
      input = input.dup
      input.gsub!("\uFF00","\n")
      add_code(input)
    end
  end
end