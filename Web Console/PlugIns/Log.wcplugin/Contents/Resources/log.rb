#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require_relative 'bundle/bundler/setup'
require 'webconsole'

require_relative "lib/controller"

WebConsole::Log::View.new
