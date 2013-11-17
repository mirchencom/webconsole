#!/usr/bin/env ruby

require 'webconsole'

BASE_DIRECTORY = File.join(File.dirname(__FILE__))
LIB_DIRECTORY = File.join(BASE_DIRECTORY, "lib")
CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE

# Window Manager
window_id = ENV['WINDOWID']
window_manager = WebConsole::WindowManager.new(window_id)
BASE_PATH = File.expand_path(BASE_DIRECTORY)
window_manager.base_url_path = BASE_PATH

# Controller
controller = WcPrint::Controller.new(window_manager)

ARGF.each do |line|
  controller.parse_line(line)
end