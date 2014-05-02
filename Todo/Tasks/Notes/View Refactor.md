# View Refactor

* [ ] Finish refactoring Search plugin, now make it properly use Controller vs. View separation
* [ ] All plugins use new title helper
* [ ] Add Dependencies extension tests to main webconsole gem tests
* [ ] Make Search plugin work with Dependencies extension in order to test dependencies namespacing
* [ ] Make data a properly namespaced plugin
* [ ] Add title to the window, do tests for it, then wrap up `wcdependencies`
	* Test title with and without environment variable set
	* Test loading the view without a set title
	* Test setting the title via the attribute
	* Test setting the title via the environment variable
* [ ] Enforce these new require rules
	* There should only be one require per load path, this means
		* `require 'webconsole'` goes only in the tests and in the main class
		* Tests should only require the classes they need to test
* [ ] Add new view files to rake tests
* [ ] `wcdependencies` and `wcrepl` can probably lose their prefix, in fact I think I should move towards removing the `wc` prefix altogether
* [ ] Gem tests should now run tests for `wcdata`, `wcdependencies`, and `wcrepl`
* [ ] For WcREPL and WcDependencies, the *tests* should require `webconsole` via Bundler!
* [ ] More API changes:
	* `WindowManager` to `Window`
	* `Controller` has a `View` has a `Window`
	* Make a `Controller` class again that just initializes a `View`
* [ ] Setup `wcsearch` to use local gem
* [ ] When I add the plugin name environment variable, make sure it gets tested in the Xcode tests, because those tests won't exist anywhere else
* [ ] Maybe there should be a simple controller subclass like this:

		  class Controller

		    def initialize
		      @view = View.new
		    end


## Setup a Test

* [ ] Start moving plugins over to the new version of the gem
* [ ] Update the HTML plugin first
	* Delete all the bundle files except the `Gemfile`
	* Point it to the relative path to the `webconsole` gem

## Update the `webconsole` gem for all plugins

* [ ] Bump the `webconsole` gem version number
* [ ] Delete the gem globally
* [ ] Install the new version of the gem


## Todo


* [ ] Also allow different rendering engines, e.g., slim etc...

* [ ] Hard link in `Gemfile`'s to older version of the gem
* [ ] Then I can freely refactor until the API looks right

The idea here is to get `view` style code out of the controller.

The controller shouldn't know about JavaScript, css, etc...

The controller's delegate should be a view

The idea is that the view.rb could be replaced by another implementation for example to do a Native Cocoa view with no change to the controller.

	server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root


## Notes

* `Controller`: Should not include any HTML, CSS, or JavaScript. 
* `View`: 
* `WindowManager`: A thin layer around the windows native API, you should be able to replace the `Window_Manager` with a `WindowManager` that wraps around Safari while keeping all the other code for example.