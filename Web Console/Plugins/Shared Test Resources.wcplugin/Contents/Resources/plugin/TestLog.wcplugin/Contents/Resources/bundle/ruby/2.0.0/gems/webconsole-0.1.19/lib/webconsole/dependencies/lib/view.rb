module WebConsole::Dependencies
  
  class View < WebConsole::View
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), '..')
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize
      super
      self.base_url_path = File.expand_path(BASE_DIRECTORY)
      load_erb_from_path(VIEW_TEMPLATE)
    end

    ADD_MISSING_DEPENDENCY_FUNCTION = "addMissingDependency"
    def add_missing_dependency(name, type, installation_instructions = nil)
      do_javascript_function(ADD_MISSING_DEPENDENCY_FUNCTION, [name, type, installation_instructions])
    end
  end
end