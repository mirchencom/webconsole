#!/usr/bin/env ruby

require 'webconsole'

SHARED_RESOURCES_PATH = WebConsole::resource_path_for_plugin("Shared Resources")
WEB_CONSOLE_CONSTANTS_FILE = File.join(SHARED_RESOURCES_PATH, "Shared/ruby/web_console_constants")
require WEB_CONSOLE_CONSTANTS_FILE

CONTROLLER_FILE = File.join(File.dirname(__FILE__), "controller")
require CONTROLLER_FILE

WINDOW_MANAGER_FILE = File.join(File.dirname(__FILE__), "window_manager")
require WINDOW_MANAGER_FILE

# Window Manager
window_id = ENV[WINDOW_ID_KEY]
window_manager = WcIRB::WindowManager.new(window_id)

# Controller
controller = WcIRB::Controller.new(window_manager)

ARGF.each do |line|
  controller.parse_line(line)
end