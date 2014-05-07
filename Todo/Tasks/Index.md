# Index

## Title

* [ ] Figure out testing the tasks termination status, then figure out making the exit status only pass if the termination status is valid, and have it only be valid if the environment variables are properly set
* [ ] Construct an environment dictionary in the plugin (from a category?) and then modify the `WCLPluginTask` API to include a dictionary:

		+ (void)runTask:(NSTask *)task environmentDictionary:(NSDictionary *)dictionary delegate:(id<WCLPluginTaskDelegate>)delegate;

* [ ] Write environment dictionary tests
	* A simple script that exits with an exit status of 1 if the dictionary keys aren't set
* [ ] Run all plugin tests
* [ ] Do Mavericks warnings update
* [ ] When I add the plugin name environment variable for title, make sure it gets tested in the Xcode tests, because those tests won't exist anywhere else
* [ ] Do that `title` helper method for all plugins

	    def title
	      return ENV.has_key?(WebConsole::PLUGIN_NAME_KEY)? ENV[WebConsole::PLUGIN_NAME_KEY] : "Dependencies"
	    end


	* The plugin name should be included as a environment variable
	* Use `PLUGIN_NAME_KEY` for this
	* Add a test for it

## Building & Running Plugins

* [ ] Make it so the user can have plugins loaded from their user `Application Support` folder
* [ ] Move `Git.wcplugin` somewhere else, make it load from `Application Support`
* [ ] Upload `Git.wcplugin` to github
* [ ] TextMate Bundle
* [ ] Shell Scripts
	* These require the Ruby gem
	* For now just `gem install webconsole` globally
	* Test the HTML and Markdown Gems on Virtual Machine
* [ ] `http` links should open in the browser?
	* Test `WebConsole::Dependencies` works with this (e.g., linking to "homebrew" opens in the browser)
* [ ] Fix the toolbar

## Continued

* [ ] Work on [Web Console Documentation](Tasks/Web%20Console%20Documentation.md)
* [ ] Figure out how to publish various extras
	* TextMate Bundle?
	* Shell Scripts? (e.g., command line utility)
		* `wccoffee.rb`
		* `wchtml.rb`
		* `wcirb.rb`
		* `wcmarkdown.rb`
		* `wcnode.rb`
		* `wcsearch.rb`
* [ ] Fix the `PluginEditorPrototype` toolbar for screenshots
* [ ] Record screencasts
* [ ] Do an app icon