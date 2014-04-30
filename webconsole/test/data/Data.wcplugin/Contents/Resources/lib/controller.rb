require_relative "constants"
require WEBCONSOLE_FILE
require_relative "view"

module WcData
  class Controller < WebConsole::Controller

    def initialize
      super(WcData::View.new)
    end
    
    def add_key_value(key, value)
      puts "add_key_value"      
      javascript = javascript_add_key_value(key, value)
      @view.do_javascript(javascript)
    end

    def value_for_key(key)
      javascript = javascript_value_for_key(key)
      value = @view.do_javascript(javascript)
      value.chomp!
      return value
    end
    
    private
    
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