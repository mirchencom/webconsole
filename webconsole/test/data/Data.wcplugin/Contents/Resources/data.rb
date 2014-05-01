#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby

require_relative "lib/constants"
require WEBCONSOLE_FILE

require_relative "lib/controller"

# Controller
controller = WebConsole::Data::Controller.new

PATH_KEY = "Path"
path = Dir.pwd.to_s
controller.add_key_value(PATH_KEY, path)

ARGUMENTS_KEY = "Arguments"
arguments = ARGV.join(" ")
controller.add_key_value(ARGUMENTS_KEY, arguments)


# Debugging
path_value = controller.value_for_key(PATH_KEY)
puts "path_value = " + path_value.to_s

arguments_value = controller.value_for_key(ARGUMENTS_KEY)
puts "arguments_value = " + arguments_value.to_s

