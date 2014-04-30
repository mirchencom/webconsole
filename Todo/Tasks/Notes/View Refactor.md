# View Refactor

* [ ] Gem tests should now run tests for `wcdata`, `wcdependencies`, and `wcrepl`
* [ ] For WcREPL and WcDependencies, the *tests* should require `webconsole` via Bundler!
* [ ] More API changes:
	* `WindowManager` to `Window`
	* `Controller` has a `View` has a `Window`
	* Make a `Controller` class again that just initializes a `View`
* [ ] Setup `wcsearch` to use local gem
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