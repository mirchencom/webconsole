require_relative '../bundle/bundler/setup'

module WebConsole::Log
  class Controller < WebConsole::Controller
    MESSAGE_PREFIX = WebConsole::Logger::MESSAGE_PREFIX
    ERROR_PREFIX = WebConsole::Logger::ERROR_PREFIX

    def parse_input(input)
      input = input.dup
      input.sub!(/^\s*$\n/, '') # Don't process blank lines

      if input =~ /^#{MESSAGE_PREFIX}/
        input[MESSAGE_PREFIX] = ''
      elsif message =~ /^#{ERROR_PREFIX}/
        input[ERROR_PREFIX] = ''
      end

    end

    # def view
    #   if !@view
    #     @view = View.new
    #   end
    #   return @view
    # end

  end
end