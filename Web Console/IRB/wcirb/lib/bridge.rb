#!/usr/bin/env ruby

require 'webconsole'

CONTROLLER_FILE = File.join(File.dirname(__FILE__), "controller")
require CONTROLLER_FILE

WINDOW_MANAGER_FILE = File.join(File.dirname(__FILE__), "window_manager")
require WINDOW_MANAGER_FILE

# Window Manager
window_id = ENV[WC_WINDOW_ID_KEY]
window_manager = WcIRB::WindowManager.new(window_id)

# Controller
controller = WcIRB::Controller.new(window_manager)

ARGF.each do |line|
  controller.parse_line(line)
end