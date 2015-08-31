require_relative '../bundle/bundler/setup'

module WebConsole::Log
  class View < WebConsole::Controller

    def parse_input(input)
      input.gsub!(/^\s*$\n/, '') # Don't process blank lines
      puts input
    end

    # def view
    #   if !@view
    #     @view = View.new
    #   end
    #   return @view
    # end

  end
end