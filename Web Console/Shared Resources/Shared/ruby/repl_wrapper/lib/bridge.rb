#!/usr/bin/env ruby

require 'webconsole'

CONSTANTS_FILE = File.join(File.dirname(__FILE__), "constants")
require CONSTANTS_FILE
require OUTPUT_CONTROLLER_FILE

# Window Manager
window_manager = WebConsole::WindowManager.new

# Controller
controller = WcREPLWrapper::OutputController.new(window_manager)

ARGF.each do |line|
  controller.parse_output(line)
end