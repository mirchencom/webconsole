# Default Preferences Implementation

## Implementation

[Handling Default Values With NSUserDefaults – Ole Begemann](http://oleb.net/blog/2014/02/nsuserdefaults-handling-default-values/)

> A better way is to take advantage of the `registerDefaults:` method. `register​Defaults:` expects a dictionary containing the default values for all of your app’s preferences.

> To edit the default values, you should create a `DefaultPreferences.plist` file containing such a dictionary in Xcode and add it to your target. At runtime, your app can then load that file and pass its contents to `registerDefaults:`

>		NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
>		NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
>		[[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];

> When you later invoke `- [NSUserDefaults boolForKey:]` from anywhere in your code, it will return the correct default value if no specific value is stored under that key.

> Note that you have to do this on every launch of your app before you read any values from the user defaults because `registerDefaults:` does not persist the default values to disk. The `application:didFinishLaunchingWithOptions:` method is usually the right place.

[Cocoa Bindings Programming Topics: User Defaults and Bindings](https://developer.apple.com/library/mac/documentation/cocoa/conceptual/CocoaBindings/Concepts/NSUserDefaultsController.html):

>		 + (void)setupDefaults
>		 {
>		     NSString *userDefaultsValuesPath;
>		     NSDictionary *userDefaultsValuesDict;
>		     NSDictionary *initialValuesDict;
>		     NSArray *resettableUserDefaultsKeys;
>		  
>		     // load the default values for the user defaults
>		     userDefaultsValuesPath=[[NSBundle mainBundle] pathForResource:@"UserDefaults"
>		                                ofType:@"plist"];
>		     userDefaultsValuesDict=[NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
>		  
>		     // set them in the standard user defaults
>		     [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];
>		  
>		     // if your application supports resetting a subset of the defaults to
>		     // factory values, you should set those values
>		     // in the shared user defaults controller
>		     resettableUserDefaultsKeys=[NSArray arrayWithObjects:@"Value1",@"Value2",@"Value3",nil];
>		     initialValuesDict=[userDefaultsValuesDict dictionaryWithValuesForKeys:resettableUserDefaultsKeys];
>		  
>		     // Set the initial values in the shared user defaults controller
>		     [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:initialValuesDict];
>		 }

## Notes

Clearing `NSUserDefaults`, which are stored in memory.

[objective c - Where does NSUserDefaults store data on Mac OS X? - Stack Overflow](http://stackoverflow.com/questions/19234665/where-does-nsuserdefaults-store-data-on-mac-os-x):

> Regardless of OS X version, the right way to delete a defaults domain is with defaults delete bundleid or its programmatic equivalent.  ~/Library/Preferences is an implementation detail. The plists contained therein do not always contain the latest information. Prior to Mountain Lion, defaults changes are buffered in individual applications until they synchronize; in Mountain Lion and later, they are maintained in memory in cfprefsd processes and flushed to disk lazily.

[iphone - Clearing NSUserDefaults - Stack Overflow](http://stackoverflow.com/questions/545091/clearing-nsuserdefaults):

> You can remove the application's persistent domain like this:
> 
> 		NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
> 		[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
