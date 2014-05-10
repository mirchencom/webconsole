# TextMate Bundle

## If Web Console is not installed

* [ ] Should fail prettily if Web Console is not installed
* [ ] Test on Virtual Machine
* [ ] How do BBFind and Mate etc... solve this?
* [ ] Do AppleScript solution
* [ ] Add new webconsole gem everywhere
	* Update script to include TextMate bundles

### Notes

If Web Console is not installed, can I have a test in the webconsole gem that fails on import if the Web Console is not installed?

Here's how Atom.app handles this:

	if [ $OS == 'Mac' ]; then
	  ATOM_PATH=${ATOM_PATH:-/Applications} # Set ATOM_PATH unless it is already set
	  ATOM_APP_NAME=Atom.app

	  # If ATOM_PATH isn't a executable file, use spotlight to search for Atom
	  if [ ! -x "$ATOM_PATH/$ATOM_APP_NAME" ]; then
	    ATOM_PATH=$(mdfind "kMDItemCFBundleIdentifier == 'com.github.atom'" | head -1 | xargs dirname)
	  fi

	  # Exit if Atom can't be found
	  if [ -z "$ATOM_PATH" ]; then
	    echo "Cannot locate Atom.app, it is usually located in /Applications. Set the ATOM_PATH environment variable to the directory containing Atom.app."
	    exit 1
	  fi

	  if [ $EXPECT_OUTPUT ]; then
	    "$ATOM_PATH/$ATOM_APP_NAME/Contents/MacOS/Atom" --executed-from="$(pwd)" --pid=$$ "$@"
	    exit $?
	  else
	    open -a "$ATOM_PATH/$ATOM_APP_NAME" -n --args --executed-from="$(pwd)" --pid=$$ "$@"
	  fi

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