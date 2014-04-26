#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require_relative 'bundle/bundler/setup'
require 'webconsole'

require_relative "lib/controller"

# Window Manager
window_manager = WebConsole::WindowManager.new
BASE_PATH = File.expand_path(File.dirname(__FILE__))
window_manager.base_url_path = BASE_PATH

# Controller
controller = WcPrint::Controller.new(window_manager)

ARGF.each do |line|
  controller.parse_line(line)
end