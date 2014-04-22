# Building From Source

## Requirements

1. [OS X Mavericks](http://www.apple.com/osx/)
2. [Xcode](https://developer.apple.com/xcode/)
3. Xcode Command Line Tools

## Build & Run

1. Checkout the source code

		git clone git@github.com:robenkleene/Web-Console.git

2. Install the Ruby Gem

		cd webconsole
		gem build webconsole.gemspec
		gem install webconsole-0.0.0.gem

3. Open `Web Console/Web Console.xcodeproj`
4. Run in Xcode

## Recommended Ruby Setup

Web Console is currently being tested with Ruby version 1.9.3-p194, instructions for setting up this version of Ruby:

1. [Install `rbenv` via Homebrew](https://github.com/sstephenson/rbenv#homebrew-on-mac-os-x):

		brew install rbenv ruby-build

2. Add `eval "$(rbenv init -)"` to your `.bash_profile`.
3. install Ruby version 1.9.3-p194

		rbenv install 1.9.3-p194

4. Set `rbenv` to use this version of Ruby:

		rbenv global 1.9.3-p194

5. Confirm the Ruby version:

		$ ruby -v
		ruby 1.9.3p194 (2012-04-20 revision 35410) [x86_64-darwin13.1.0]

## Tests

### Running Tests From the Command Line

<!-- TODO The "webconsole" ruby gem is required  -->