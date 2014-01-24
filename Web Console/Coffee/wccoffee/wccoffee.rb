#!/usr/bin/env ruby

require 'Shellwords'
require 'webconsole'

CONSTANTS_FILE = File.join(File.dirname(__FILE__), "lib", "constants")
require CONSTANTS_FILE
require CONTROLLER_FILE
require WINDOW_MANAGER_FILE

# Window Manager
window_manager = WcCoffee::WindowManager.new
# Controller
controller = WcCoffee::Controller.new(window_manager)

if !ENV.has_key?(WebConsole::WINDOW_ID_KEY)
  # Set the environment variable if it hasn't been set already
  # So that when the second window_manager gets instansiated it
  # will have the same window_id
  ENV[WebConsole::WINDOW_ID_KEY] = window_manager.window_id.to_s
end

command = "coffee | #{Shellwords.escape(BRIDGE_EXECUTABLE)}"
pipe = IO.popen(command, "w")
ARGF.each do |line|
  controller.parse_line(line)
  pipe.write(line)
end
