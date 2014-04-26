# Index

## Refactoring

* [ ] Replace my require full path with `require_relative` everywhere
	* Search for `LIB_` e.g., `LIB_DIRECTORY`
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
* [ ] Move `Git.wcplugin` somewhere else, make it load from `Application Support`
* [ ] Update all global ruby gems on main machine
* [ ] Controllers should not call `do_javascript` or `load_html` directly, instead those should call helper methods, also the `self.javascript_function` should be moved onto the view

## Building & Running Plugins

* [ ] Make it so the user can have plugins loaded from their user `Application Support` folder
* [ ] TextMate Bundle
* [ ] Shell Scripts
	* These require the Ruby gem
	* For now just `gem install webconsole` globally
	* Test the HTML and Markdown Gems on Virtual Machine

## Continued

* [ ] Work on [Web Console Documentation](Tasks/Web%20Console%20Documentation.md)
* [ ] Figure out how to publish various extras
	* TextMate Bundle?
	* Shell Scripts?
		* `wccoffee.rb`
		* `wchtml.rb`
		* `wcirb.rb`
		* `wcmarkdown.rb`
		* `wcnode.rb`
		* `wcsearch.rb`
* [ ] Fix the `PluginEditorPrototype` toolbar for screenshots
* [ ] Record screencasts
* [ ] Do an app icon