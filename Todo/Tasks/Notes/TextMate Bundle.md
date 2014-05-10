# TextMate Bundle

* [ ] Get HTML plugin workings by requiring "webconsole" and making the script work
* [ ] Get one of the scripts working without the external shell script dependency
* [ ] Figure out what these do

		$: << ENV['TM_BUNDLE_SUPPORT']
		$: << ENV['TM_SUPPORT_PATH']

* [x] Make the new bundle
* [x] Move the existing commands over
* [ ] Shebangs should all use system ruby
* [ ] Add the webconsole gem as dependency
* [ ] Figure out how to add the webconsole gem as a dependency

* [ ] List commands to support
* [ ] Delete commands from Roben bundle
* [ ] IRB has some problems with the prompt when running a whole file through

## If Web Console is not installed

* [ ] Should fail prettily if webconsole is not installed
* [ ] Markdown and HTML should fail if the file path is nil

## Commands

* "Preview in HTML Plugin"
* "Preview in Markdown Plugin"
* "Search Project in Search Plugin"
* "Run in Coffee Plugin"
* "Run in IRB Plugin"
* "Run in Node Plugin"

## Notes

### Dependencies

	#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby

	$: << ENV['TM_BUNDLE_SUPPORT']
	$: << ENV['TM_SUPPORT_PATH']

	require 'lib/markdown'
	require 'lib/escape'

	# get the list itself
	listtxt = $stdin.read()
	list = Markdown::List.parse(listtxt)

	# now we need to figure out where we were when we hit enter
	offsetline = ENV['TM_LINE_NUMBER'].to_i() - ENV['TM_INPUT_START_LINE'].to_i()
	index = ENV['TM_LINE_INDEX'].to_i()

	list.break(offsetline, index, "$0", true) { |l| e_sn(l) }
	print list.to_s()