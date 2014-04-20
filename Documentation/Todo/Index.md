# Index

## Plugin Dependencies

* [x] Ruby Gem Solution
* [x] Finish wcdependencies main API
	* With tests
	* Should only create a `window_manager` if a check fails
* [x] Rake tests for wcdependencies
	* Also add to main tests
* [x] Shell command solution
* [ ] Add it to `wccoffee`, `wcnode`, and `wcsearch`
	* When integrating with a plugin, process should end if a check fails
* [ ] Perform ruby gem test on virtual machine
* [ ] Perform shell command test on virtual machine
* [ ] Try running plugin tests again on virtual machine
* [ ] Setup all gems using [Plugin Dependencies](Notes/Plugin%20Dependencies.md)

## Dependencies to check for

* `wcsearch`
	* `pwd`
	* `grep`
* `wcnode`
	* `node`

## Refactoring

* [ ] Switch back to branch master
* [ ] Replace my require full path with `require_relative` everywhere
* [ ] Replace all javascript calls with new helper `def self.javascript_function(function, arguments)`
	* Do a test for this
* [ ] I might be overly aggressively specifying scope, e.g.:

		module WcIRB
		  class Wrapper < WcREPL::Wrapper
		  
		  	# [...]
		  
		    def output_controller
		      if !@output_controller
		        @output_controller = WcIRB::OutputController.new(window_manager)
		      end
		      return @output_controller
		    end
	
	I don't think I need to specify `WcIRB::` because I'm already in the `WcIRB` module?

* [ ] Do that title helper method for all plugins
	* The plugin name should be included as a environment variable
	* Use `PLUGIN_NAME_KEY` for this
	* Add a test for it
* [ ] `http` links should open in the browser
	* Test missing dependencies homebrew link works with this

## Continued

* [ ] Work on [Web Console Documentation](Tasks/Web%20Console%20Documentation.md)
* [ ] Figure out how to publish the Ruby Gem
* [ ] Figure out how to publish various extras
	* TextMate Bundle?
	* Shell Scripts?
		* `wccoffee.rb`
		* `wchtml.rb`
		* `wcirb.rb`
		* `wcmarkdown.rb`
		* `wcnode.rb`
		* `wcsearch.rb`
* [ ] Make it so the user can have plugins loaded from their user `Application Support` folder
* [ ] Fix the `PluginEditorPrototype` toolbar for screenshots

## Later

* [ ] Give Web Console a proper version number
* [ ] Record screencasts