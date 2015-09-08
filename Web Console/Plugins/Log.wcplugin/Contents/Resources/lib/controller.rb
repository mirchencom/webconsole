require_relative '../bundle/bundler/setup'
require_relative 'view'

module WebConsole::Log
  class Controller < WebConsole::Controller
    MESSAGE_PREFIX = WebConsole::Logger::MESSAGE_PREFIX
    ERROR_PREFIX = WebConsole::Logger::ERROR_PREFIX

    def initialize
      @view = View.new
    end

    def parse_input(input)
      message = input.dup
      message.sub!(/^\s*$\n/, '') # Don't process blank lines
      if message =~ /^#{MESSAGE_PREFIX}/
        message[MESSAGE_PREFIX] = ''
        message.rstrip!
        if !message.empty?
          view.log_message(message)
        end
      elsif message =~ /^#{ERROR_PREFIX}/
        message[ERROR_PREFIX] = ''
        message.rstrip!
        if !message.empty?
          view.log_error(message)
        end
      end

    end

  end
end