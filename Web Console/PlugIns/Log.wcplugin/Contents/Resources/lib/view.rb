require_relative '../bundle/bundler/setup'

module WebConsole::Log
  class View < WebConsole::View
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "view")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize
      super
      self.base_url_path = File.expand_path(BASE_DIRECTORY)
      load_erb_from_path(VIEW_TEMPLATE)
    end

    def log_message
    end
    
    def log_error
    end

  end
end
