# Index

## JavaScript Helper Method to `WebConsole::View`

* [ ] Add the helper `def self.javascript_function(function, arguments)` to the `WebConsole::Window_Manager`
* [ ] Write a test for it
* [ ] Publish gem
* [ ] Update gems with bundler
* [ ] Replace `wcdependencies` implementation of `javascript_function`
* [ ] Replace all `do_javascript` calls with new helper method calls in gems
* [ ] The javascript string methods should also be moved from the controller
* [ ] HTML Plugin `tc_controller` is bringing out an API bug, if a base URL is not set, then a second call to load HTML will fail because the `window_id` will get passed in as the base URL
* [ ] Make HTML test pass, and do similar for markdown
* [ ] Add those to main tests

### Consider

* Make `do_javascript` private? (And instead make helper methods that call it)
* Controllers should not call `do_javascript` or `load_html` directly, instead those should call helper methods, also the `self.javascript_function` should be moved onto the view

## Refactoring

* [ ] Do that `title` helper method for all plugins
	* The plugin name should be included as a environment variable
	* Use `PLUGIN_NAME_KEY` for this
	* Add a test for it
* [ ] `http` links should open in the browser?
	* Test missing dependencies (e.g., linking to "homebrew") work with this

## Building & Running Plugins

* [ ] Move `Git.wcplugin` somewhere else, make it load from `Application Support`
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