require 'webconsole'

module WcData
  class Controller < WebConsole::Controller
    BASE_DIRECTORY = File.join(File.dirname(__FILE__), "..")
    VIEWS_DIRECTORY = File.join(BASE_DIRECTORY, "view")
    VIEW_TEMPLATE = File.join(VIEWS_DIRECTORY, 'view.html.erb')

    def initialize(delegate = nil)      
      super(delegate, VIEW_TEMPLATE)
    end

    def add_key_value(key, value)
      javascript = javascript_add_key_value(key, value)
      if @delegate
        @delegate.do_javascript(javascript)
      end    
    end

    def value_for_key(key)
      value = nil
      if @delegate
        javascript = javascript_value_for_key(key)
        value = @delegate.do_javascript(javascript)
        value.chomp!
      end
      return value
    end
    
    private
    
    class ::String
      def javascript_escape
        self.gsub('\\', "\\\\\\\\").gsub("'", "\\\\'")
      end

      def javascript_escape!
        replace(self.javascript_escape)
      end
    end
    
    def javascript_add_key_value(key, value)
      key.javascript_escape!
      value.chomp!
      value.javascript_escape!
      %Q[addKeyValue('#{key}', '#{value}');]
    end
    
    def javascript_value_for_key(key)
      key.javascript_escape!
      %Q[valueForKey('#{key}');]
    end
  end
end