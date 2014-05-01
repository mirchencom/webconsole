require_relative "constants"
require WEBCONSOLE_FILE
require_relative "view"

module WcData
  class Controller < WebConsole::Controller

    def initialize
      @view = View.new
    end
    
    def add_key_value(key, value)
      value.chomp!
      @view.add_key_value(key, value)
    end

    def value_for_key(key)
      return @view.value_for_key(key)
    end
    
  end
end