# Upgrade Ruby

* [ ] Redo Bundler to use `2.0.0-p247`
	* Add `ruby '2.0.0'` to all `Gemfile`s
	* Delete `.bundle` folder for all plugins
	* Run
* [ ] In all plugins and scripts, switch shebang to use system ruby

## For all plugins

1. Add `ruby '2.0.0'` to the `Gemfile`
2. Delete the `.bundle` directory
3. Delete the `bundle` directory
4. Delete the `Gemfile.lock` file
4. Run `bundle install --standalone`

## Notes

Installation command:

	rbenv install 2.0.0-p247

Set `rbenv` ruby version

	rbenv global 2.0.0-p247

Mavericks Ruby version output:

	ruby 2.0.0p247 (2013-06-27 revision 41674) [universal.x86_64-darwin13]

### Shebang

From TextMate:

		#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby -KU

Mine:

		#!/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin/ruby
