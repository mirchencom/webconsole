require_relative '../bundle/bundler/setup'

module WebConsole::Log
  class Controller < WebConsole::Controller
    MESSAGE_PREFIX = WebConsole::Logger::MESSAGE_PREFIX
    ERROR_PREFIX = WebConsole::Logger::ERROR_PREFIX

    def parse_input(input)
      message = input.dup

      message.sub!(/^\s*$\n/, '') # Don't process blank lines

      if message =~ /^#{MESSAGE_PREFIX}/
        message[MESSAGE_PREFIX] = ''
        view.log_message(message)
      elsif message =~ /^#{ERROR_PREFIX}/
        message[ERROR_PREFIX] = ''
        view.log_error(message)
      end

    end

    def view
      if !@view
        @view = View.new
      end
      return @view
    end

  end
end