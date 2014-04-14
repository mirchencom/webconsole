# Environment Preference Pane

* [ ] Delete these defines after environment is tested as working properly:

Selected tab

	#define kDefaultPreferencesSelectedTabKey @"WCLPreferencesSelectedTab"

Encoding

	#define kEnvironmentVariableEncodingKey @"LC_ALL" 
	#define kEnvironmentVariableEncodingValue @"en_US.UTF-8"

Path

	#define kEnvironmentVariablePathKey @"PATH"
	#define kEnvironmentVariablePathValue @"/Users/robenkleene/.rbenv/shims:/Users/robenkleene/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/npm/bin/";

* [ ] Test if I can migrate this to defaults to:

	    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];

## Notes

My `PATH`:

	#define kEnvironmentVariablePathValue @"/Users/robenkleene/.rbenv/shims:/Users/robenkleene/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/share/npm/bin/";

Clear `NSUserDefaults`:

	defaults delete com.1percenter.Web-Console

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