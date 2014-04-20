# Index

## Plugin Dependencies

* [x] Ruby Gem Solution
* [ ] Finish wcdependencies main API
	* With tests
* [ ] Add it to `wccoffee`, `wcnode`, and `wcsearch`
* [ ] Shell command solution
* [ ] Perform ruby gem test on virtual machine
* [ ] Perform node module test on virtual machine
* [ ] Try running plugin tests again on virtual machine
* [ ] Setup all gems using [Plugin Dependencies](Notes/Plugin%20Dependencies.md)

## Refactoring

* [ ] Replace my require full path with `require_relative` everywhere
* [ ] Replace all javascript calls with new helper `def self.javascript_function(function, arguments)`
	* Do a test for this
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