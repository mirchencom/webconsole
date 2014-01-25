require WebConsole::shared_resource("ruby/repl_wrapper/repl_wrapper")

module WcIRB
  class InputController < WcREPLWrapper::InputController
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "view")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize(delegate = nil)      
      super(delegate, VIEW_TEMPLATE)
    end

    def parse_input(input)
      input = input.dup
      
      puts "input = " + input

      super(input)
    end

  end
end