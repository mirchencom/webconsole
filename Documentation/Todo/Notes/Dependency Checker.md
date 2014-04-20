# Dependency Checker

* [ ] Has to check a batch of dependencies
* [ ] Dependencies should only load the dependency view template HTML if a dependency check fails. This probably means changing the `Controller` API to not automatically load HTML
	* It only needs to even initialize a `window_manager` if the check fails
* [ ] Dependencies should be specified in a configuration file
	* Should include an error message
	* Should include an install message

## Dependency Checker Refactor

* The `controller` should not be a WebConsole controller subclass.
	* Instead a controller should be instantiated when a dependency check first fails



## Using a preprocessor

Pass a method as an argument

* [Passing a method as a parameter in Ruby - Stack Overflow](http://stackoverflow.com/questions/522720/passing-a-method-as-a-parameter-in-ruby)

## Options Hash

[hash - How to implement options hashes in Ruby? - Stack Overflow](http://stackoverflow.com/questions/14866910/how-to-implement-options-hashes-in-ruby):

>		class Person
>		
>			def initialize(opts = {})
>				@options = opts
>			end
>		
>			def my_age
>				return @options[:age] if @options.has_key?(:age)
>			end
>		
>		end


## Notes

File

	dependencies.rb

Running

	WebConsole::Dependencies::check_dependency(command, type, :options => :installation_instructions)
	WebConsole::Dependencies::check(path)

Hits the delegate with `dependency_check_passed(stuff)`

Should be a file at:

	/Web Console/Web Console/PlugIns/Shared Resources.wcplugin/Contents/Resources/ruby/wcdependenecies

## Structure

* `Checker`
	* Has the main methods that get called
	* Initializes a `Controller`, `Checker`, and `WindowManager` and ties them together
* `Controller`	
	* `delegate` is `WindowManager`
* `DependencyChecker`
	* `delegate` is `Controller`
	* Calls the `DependencyTester`
* `DependencyTester`
* `WindowManager`

## Checking if a program exists

	$ type -a coffee
	coffee is /usr/local/share/npm/bin/coffee

> type sets the exit status to 0 if the specified command was found, and 1 if it could not be found.