# Environment Preference Pane

* [ ] Evaluate adding Environment Preferences Pane
	* Which files will I need to add?
* [ ] Setup defaults for environment variables
	* `#define kDefaultPreferencesSelectedTabKey @"WCLPreferencesSelectedTab"`, should be replaced with this system
	* As should these:
	
			#define kEnvironmentVariableEncodingKey @"LC_ALL" 
			#define kEnvironmentVariableEncodingValue @"en_US.UTF-8"
	
	* And these:

			#define kEnvironmentVariablePathKey @"PATH"
			#define kEnvironmentVariablePathValue @"/Users/robenkleene/.rbenv/shims:/Users/robenkleene/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/npm/bin/";

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