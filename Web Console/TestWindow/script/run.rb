#!/usr/bin/env ruby

require 'webconsole'

window_id = ENV['WINDOWID']
window_manager = WebConsole::WindowManager.new(window_id)
window_manager.load_html("Hello World")