module WebConsole
  class Controller
    attr_reader :view
    def initialize(view = nil)
      @view = view
      if !@view
        @view = View.new
      end
    end
  end
end