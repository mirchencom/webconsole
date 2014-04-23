# Plugin Dependencies

## Ruby Gems

1. Run `bundle init` to create a `Gemfile`
2. Add `.bundle` to `.gitignore`
3. Edit the `Gemfile` to add required gems
4. Run `bundle install --standalone`
5. Add `require_relative 'bundle/bundler/setup'` to the script

## Updating Gems

	bundle update
	bunlde cleanup