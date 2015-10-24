#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require_relative 'bundle/bundler/setup'
require 'webconsole'
require 'webconsole/logger'

logger = WebConsole::Logger.new
logger.info("Testing log message")
logger.error("Testing log error")
logger.show