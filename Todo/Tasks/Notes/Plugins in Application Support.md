# Plugins in Application Support

## Todo

* [ ] Continue with `WCLPluginManager` tests, make counts of valid loaded plugins in the `pluginsPaths`

## Notes

	~/Library/Application Support/Web Console/Plugins

### Loading Code

[Code Loading Programming Topics: Loading Bundles](https://developer.apple.com/librarY/mac/documentation/Cocoa/Conceptual/LoadingCode/Tasks/LoadingBundles.html):

> Loading Cocoa Bundles: Example Code
> In most applications, the five steps of bundle loading take place during the startup process as it searches for and loads plug-ins. Listing 1 shows the implementation for a pair of methods that locate bundles, create NSBundle objects, load their code, and find and instantiate the principal class of each discovered bundle. An explanation follows the listing.

### Getting Plugin Paths

[osx - Cocoa: Correct way to get list of possible PlugIns directories for an app? - Stack Overflow](http://stackoverflow.com/questions/4007341/cocoa-correct-way-to-get-list-of-possible-plugins-directories-for-an-app):

> n a Cocoa app generally we can install a plugin bundle in one of a number of places. If for example the app is called "MyApp" you'd be able to install the plugin at:
> 
>		/Applications/MyApp.app/Contents/PlugIns
>		~/Library/Application Support/MyApp/PlugIns
>		/Library/Application Support/MyApp/PlugIns
>		/Network/Library/Application Support/MyApp/PlugIns
>		I'm building an NSArray of paths to search in the correct order but I'm pretty sure I'm doing this wrong since it feels like I'm doing too much work for something Apple seem to provide a lot of functions for.
>		
>		NSArray *systemSearchPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSAllDomainsMask, YES);
>		NSMutableArray *searchPaths = [NSMutableArray array];
>		
>		NSFileManager *fileManager = [NSFileManager defaultManager];
>		
>		for (NSString *systemPath in systemSearchPaths) {
>		    NSString *systemPluginsPath = [systemPath stringByAppendingPathComponent:@"PlugIns"];
>		    // FIXME: Remove debug code
>		    NSLog(@"Considering plugin path %@", systemPluginsPath);
>		    if ([fileManager fileExistsAtPath:systemPluginsPath]) {
>		        [searchPaths addObject:systemPluginsPath];
>		    }
>		}
>		
>		[searchPaths addObject:[[NSBundle mainBundle] builtInPlugInsPath]];
>		This results in the Array returned by NSSearchPathForDirectoriesInDomains, with the builtInPlugInsPath value appended to the end.
> 
> However, it actually searches directories like "~/Library/Application Support/PlugIns" (missing the "MyApp") folder. Before I start hacking the code to inject the name of my application (which is subject to change at any time), am I doing this wrong?
> 
> Is there a way to just tell Cocoa "give me all search paths for 'PlugIns'" directories for this application"?

### Getting the file name

[osx - Cocoa: Correct way to get list of possible PlugIns directories for an app? - Stack Overflow](http://stackoverflow.com/questions/4007341/cocoa-correct-way-to-get-list-of-possible-plugins-directories-for-an-app):

> You can get the name of your application at run time by asking the main bundle for its info dictionary and looking for kCFBundleNameKey therein. When you rename your application, change the bundle name in your Info.plist.

### General Application Support

[objective c - Programatically get path to Application Support folder - Stack Overflow](http://stackoverflow.com/questions/8430777/programatically-get-path-to-application-support-folder):

> Best practice is to use NSSearchPathForDirectoriesInDomains with NSApplicationSupportDirectory as "long winded" as it may be.
> 
> Example:
> 
>		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
>		NSString *applicationSupportDirectory = [paths firstObject];
>		NSLog(@"applicationSupportDirectory: '%@'", applicationSupportDirectory);

[File System Programming Guide: Managing Files and Directories](https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/ManagingFIlesandDirectories/ManagingFIlesandDirectories.html):

> Listing 6-1 Creating a custom directory for app files
>
>		- (NSURL*)applicationDirectory
>		{
>		    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
>		    NSFileManager*fm = [NSFileManager defaultManager];
>		    NSURL*    dirPath = nil;
>		 
>		    // Find the application support directory in the home directory.
>		    NSArray* appSupportDir = [fm URLsForDirectory:NSApplicationSupportDirectory
>		                                    inDomains:NSUserDomainMask];
>		    if ([appSupportDir count] > 0)
>		    {
>		        // Append the bundle ID to the URL for the
>		        // Application Support directory
>		        dirPath = [[appSupportDir objectAtIndex:0] URLByAppendingPathComponent:bundleID];
>		 
>		        // If the directory does not exist, this method creates it.
>		        // This method call works in OS X 10.7 and later only.
>		        NSError*    theError = nil;
>		        if (![fm createDirectoryAtURL:dirPath withIntermediateDirectories:YES
>		                   attributes:nil error:&theError])
>		        {
>		            // Handle the error.
>		 
>		            return nil;
>		        }
>		    }
>		 
>		    return dirPath;
>		}
