#!/usr/bin/env ruby

require 'webconsole'

CONTROLLER_FILE = File.join(File.dirname(__FILE__), "controller")
require CONTROLLER_FILE

WINDOW_MANAGER_FILE = File.join(File.dirname(__FILE__), "window_manager")
require WINDOW_MANAGER_FILE

# Window Manager
window_manager = WcCoffee::WindowManager.new

# Controller
controller = WcCoffee::Controller.new(window_manager)

ARGF.each do |line|
  controller.parse_line(line)
end