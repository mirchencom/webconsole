require_relative '../bundle/bundler/setup'

module WebConsole::Log
  class Controller < WebConsole::Controller
    MESSAGE_PREFIX = WebConsole::Logger::MESSAGE_PREFIX
    ERROR_PREFIX = WebConsole::Logger::ERROR_PREFIX

    def parse_input(input)
      input.gsub!(/^\s*$\n/, '') # Don't process blank lines
puts "MESSAGE_PREFIX = " + MESSAGE_PREFIX.to_s
puts "ERROR_PREFIX = " + ERROR_PREFIX.to_s
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