module WcData
  class View < WebConsole::View
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "view")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize
      super
      self.base_url_path = File.expand_path(BASE_DIRECTORY)
      self.load_erb_from_path(VIEW_TEMPLATE)
    end

    ADD_KEY_VALUE_JAVASCRIPT_FUNCTION = "addKeyValue"
    def add_key_value(key, value)
      do_javascript_function(ADD_KEY_VALUE_JAVASCRIPT_FUNCTION, [key, value])
    end
    
    VALUE_FOR_KEY_JAVASCRIPT_FUNCTION = "valueForKey"
    def value_for_key(key)
      value = do_javascript_function(VALUE_FOR_KEY_JAVASCRIPT_FUNCTION, [key])
      value.chomp!
      return value
    end
  end
end