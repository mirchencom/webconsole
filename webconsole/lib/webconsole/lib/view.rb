require_relative "window"
require_relative "view/javascript"
require_relative "view/erb"
require_relative "view/resources"

module WebConsole
  class View < Window

    # Properties
    def initialize(window_id = nil, view_id = nil)
      super(window_id)
      @view_id = view_id
    end

    def view_id
      @view_id ||= ENV.has_key?(SPLIT_ID_KEY) ? ENV[SPLIT_ID_KEY] : split_id
    end

    private
    
    # Web

    def arguments_with_target(arguments)
      super(arguments).push(view_id)
    end

  end
end