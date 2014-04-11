# Plugin Preferences

Everything in the Plugin Preference pane should edit the actual bundle

## Implementation Details

- Separate preference for assigning a plugin based on file extension?
- Disabling a plugin by changing it's file extensions? User preferences vs. editing the backing 
- Default plugin for file extension?

## Todo

The goal is to get this UI working using Core Data as backing

- Make hitting enter edit the plugin name and save it to Core Data
- Make it so you can edit the file extensions and save them to Core Data
- Make it so you can edit the command and save it to Core Data
- Make the choose panel work, start with a logical default?
- Make it so the enabled checkbox works? Actually don't include an enabled checkbox for now (because you can disable a plugin just by not mapping it to any file extensions)
- Add user vs. Built-In
- Have some of the UI (Command and File Extensions), show and hide automatically based on whether they are available?
- Should preserve the last selected preference pane view
- Need Plugin UUID for mapping preferences to renamed plugins


## Resources

- [How to Use Cocoa Bindings and Core Data in a Mac App | Ray Wenderlich](http://www.raywenderlich.com/21752/how-to-use-cocoa-bindings-and-core-data-in-a-mac-app)
