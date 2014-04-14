# Environment Preference Pane

* [ ] Delete environment dictionary here, see if it is deleted from the real user app preferences
* [ ] Implement `DefaultPreferences.plist` system
* [ ] Write tests for it
* [ ] Setup defaults for environment variables
	* `#define kDefaultPreferencesSelectedTabKey @"WCLPreferencesSelectedTab"`, should be replaced with this system
	* As should these:
	
			#define kEnvironmentVariableEncodingKey @"LC_ALL" 
			#define kEnvironmentVariableEncodingValue @"en_US.UTF-8"
	
	* And these:

			#define kEnvironmentVariablePathKey @"PATH"
			#define kEnvironmentVariablePathValue @"/Users/robenkleene/.rbenv/shims:/Users/robenkleene/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/npm/bin/";

* [ ] After above is clear, figure out a solution for pragmatically setting my `PATH` back to:

		/Users/robenkleene/.rbenv/shims:/Users/robenkleene/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/npm/bin/

* [ ] Test if I can migrate this to defaults to:

	    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];

## Notes

	#define kEnvironmentVariablePathValue @"/Users/robenkleene/.rbenv/shims:/Users/robenkleene/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/npm/bin/";

### Files to Modify

* `WCLAppDelegate`
* `MainMenu.xib`

### Files to Add

* `WCLPreferencesWindowController.h`
* `WCLPreferencesWindowController.m`
* `WCLPreferencesWindowController.xib`
* `WCLEnvironmentViewController.h`
* `WCLEnvironmentViewController.m`
* `WCLEnvironmentViewController.xib`



### Tests to Add