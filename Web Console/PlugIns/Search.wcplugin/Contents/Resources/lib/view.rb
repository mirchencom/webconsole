module WebConsole::Search
  class View < WebConsole::View
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), '..')
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "views")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize
      super
      self.base_url_path = File.expand_path(BASE_DIRECTORY)
      self.load_erb_from_path(VIEW_TEMPLATE)
    end

    ADD_FILE_JAVASCRIPT_FUNCTION = "addFile"
    def add_file(file_path, display_file_path)
      do_javascript_function(ADD_FILE_JAVASCRIPT_FUNCTION, [file_path, display_file_path])
    end
    
    
    def add_line_to_file(line, file)
    end
  end
end