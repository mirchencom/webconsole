#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require_relative 'bundle/bundler/setup'
require 'webconsole'

require_relative "lib/controller"

controller = WebConsole::Log::Controller.new

ARGF.each do |line|
  controller.parse_input(line)
end