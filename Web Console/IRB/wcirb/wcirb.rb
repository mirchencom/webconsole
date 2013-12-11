#!/usr/bin/env ruby

require 'webconsole'

LIB_DIRECTORY = File.join(File.dirname(__FILE__), "lib")

CONTROLLER_FILE = File.join(LIB_DIRECTORY, "controller")
require CONTROLLER_FILE

WINDOW_MANAGER_FILE = File.join(LIB_DIRECTORY, "window_manager")
require WINDOW_MANAGER_FILE

# Window Manager
window_id = ENV['WINDOWID']
window_manager = WcIRB::WindowManager.new(window_id)

# Controller
controller = WcIRB::Controller.new(window_manager)

ARGF.each do |line|
  controller.parse_line(line)
end