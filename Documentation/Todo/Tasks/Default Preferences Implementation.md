# Default Preferences Implementation

## Todo

* [ ] Write tests for these
* [ ] Figure out what the PATH variable has by default

## Implementation

[Handling Default Values With NSUserDefaults – Ole Begemann](http://oleb.net/blog/2014/02/nsuserdefaults-handling-default-values/)

> A better way is to take advantage of the `registerDefaults:` method. `register​Defaults:` expects a dictionary containing the default values for all of your app’s preferences.

> To edit the default values, you should create a `DefaultPreferences.plist` file containing such a dictionary in Xcode and add it to your target. At runtime, your app can then load that file and pass its contents to `registerDefaults:`

>		NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
>		NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
>		[[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];

> When you later invoke `- [NSUserDefaults boolForKey:]` from anywhere in your code, it will return the correct default value if no specific value is stored under that key.

> Note that you have to do this on every launch of your app before you read any values from the user defaults because `registerDefaults:` does not persist the default values to disk. The `application:didFinishLaunchingWithOptions:` method is usually the right place.

## Notes