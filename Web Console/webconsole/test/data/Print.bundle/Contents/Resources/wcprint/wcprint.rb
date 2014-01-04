#!/usr/bin/env ruby

require 'webconsole'

SHARED_RESOURCES_PATH = WebConsole::resource_path_for_plugin("Shared Resources")
WEB_CONSOLE_CONSTANTS_FILE = File.join(SHARED_RESOURCES_PATH, "Shared/ruby/web_console_constants")
require WEB_CONSOLE_CONSTANTS_FILE

LIB_DIRECTORY = File.join(File.dirname(__FILE__), "lib")
CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE

# Window Manager
window_id = ENV[WINDOW_ID_KEY]
window_manager = WebConsole::WindowManager.new(window_id)
BASE_PATH = File.expand_path(File.dirname(__FILE__))
window_manager.base_url_path = BASE_PATH

# Controller
controller = WcPrint::Controller.new(window_manager)

ARGF.each do |line|
  controller.parse_line(line)
end