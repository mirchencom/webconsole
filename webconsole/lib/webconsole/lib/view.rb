require_relative "window"
require_relative "view/javascript"
require_relative "view/erb"
require_relative "view/resources"

module WebConsole
  class View < Window

    # Properties

    def view_id
      if !@view_id
        if ENV.has_key?(SPLIT_ID_KEY)
          @view_id = ENV[SPLIT_ID_KEY]
        else
          @view_id = split_id
        end
      end
      return @view_id
    end

    private
    
    # Web

    def arguments_with_target(arguments)
      arguments = super.arugments_with_target
      arguments.push(view_id)
      return arguments
    end

  end
end