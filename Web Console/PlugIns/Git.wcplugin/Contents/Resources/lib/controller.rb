require_relative "view"

module WebConsole::Git
  class Controller < WebConsole::Controller

    attr_accessor :branch

    def initialize
      @view = View.new
    end

    def branch_name
      return @view.branch_name
    end

    def branch_name=(value)
      @view.branch_name = value
    end

  end
end