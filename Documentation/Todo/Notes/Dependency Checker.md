# Dependency Checker

* [ ] Use Dependency Checker as a test of `require_relative`
* [ ] The plugin name should be included as a environment variable
* [ ] Dependencies should be specified in a configuration file
	* Should include an error message
	* Should include an install message
* [ ] Exists with `1` if a dependency fails to be found

## Notes

File

	dependencies.rb

Running

	WebConsole::Dependencies::check_dependency(command, type, :options => :installation_instructions)
	WebConsole::Dependencies::check(path)

Hits the delegate with `dependency_check_passed(stuff)`

Should be a file at:

	/Web Console/Web Console/PlugIns/Shared Resources.wcplugin/Contents/Resources/ruby/wcdependenecies

## Checking if a program exists

	$ type -a coffee
	coffee is /usr/local/share/npm/bin/coffee

> type sets the exit status to 0 if the specified command was found, and 1 if it could not be found.