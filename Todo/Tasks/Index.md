# Index

## Refactor Cleanup

* [ ] Do S3 Backup
* [ ] Merge view refactor branch
* [ ] Git checkout master on virtual machine
* [ ] Run tests on virtual machine
* [ ] Check that repl, dependencies, HTML, and Markdown ran
* [ ] Double-check bitbucket
* [ ] Delete viewrefactor branch

## Title

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