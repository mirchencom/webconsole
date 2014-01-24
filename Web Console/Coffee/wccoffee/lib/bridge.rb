#!/usr/bin/env ruby

require 'webconsole'

CONSTANTS_FILE = File.join(File.dirname(__FILE__), "constants")
require CONSTANTS_FILE
require BRIDGE_CONTROLLER_FILE
require WINDOW_MANAGER_FILE

# Window Manager
window_manager = WcCoffee::WindowManager.new

# Controller
controller = WcCoffee::BridgeController.new(window_manager)

ARGF.each do |line|
  controller.parse_line(line)
end