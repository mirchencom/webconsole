# Design FAQ

## `XCUnit` Tests

### Why is the AppleScript API in `XCUnit` tests?

A way of blocking the test until AppleScript events happen has not been discovered.

### Why can't windows be confirmed as closing?

A way of blocking the test until the window has closed has not been discovered. E.g., There isn't a way to block until `[[[NSApplication sharedApplication] windows] count]` goes to zero.

## AppleScript API

### Why does Load HTML returns a window ID?

Showing the window here allows connecting manipulating a window just by loading HTML. I.e., running an script without using the plugin interface. Note that when running a script and using the app this way that some functionality will not work, such as terminating the running process when the window closes.

### Why does `WebConsole::plugin_read_from_standard_input` takes a plugin name rather than a window ID?

This doesn't matter because both getting the plugin's window id by name and read from standard input, in that it can only get the first window controller. Theoretically the window id method could get access to the second window controller for the plugin but that doesn't seem to matter much and the convenience of getting it by name is nice. (A problem in the app code is that mapping from a window id back to a web window controller won't be easy.)

## Web Console Gem Tests

### What should be tested in the Web Console gem versus AppleScript tests?

Everything that is logical to test in the Web Console Gem gets tested there. Everything else gets tested in AppleScript tests. I.e., AppleScript tests results in testing the parts of the API that don't logically correspond to what's already in the WebConsole tests.
