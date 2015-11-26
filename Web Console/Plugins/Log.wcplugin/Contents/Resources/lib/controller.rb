require_relative '../bundle/bundler/setup'
require 'webconsole/logger'
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
        view.log_message(message) unless message.empty?
      elsif message =~ /^#{ERROR_PREFIX}/
        message[ERROR_PREFIX] = ''
        message.rstrip!
        view.log_error(message) unless message.empty?
      end

    end

  end
end