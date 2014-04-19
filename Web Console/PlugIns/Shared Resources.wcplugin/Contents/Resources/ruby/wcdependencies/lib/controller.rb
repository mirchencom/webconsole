require 'webconsole'

module WcREPL
  class Controller < WebConsole::Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize(delegate = nil)      
      super(delegate, VIEW_TEMPLATE)
    end

    def title
      return ENV.has_key?(PLUGIN_NAME_KEY)? ENV[PLUGIN_NAME_KEY] : "Dependencies"
    end

  end
end