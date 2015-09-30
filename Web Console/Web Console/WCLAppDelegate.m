//
//  AppDelegate.m
//  Web Console
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLAppDelegate.h"

#import "WCLSplitWebWindowsController.h"

#import "WCLTaskHelper.h"

#import "WCLApplicationTerminationHelper.h"

#import "WCLPreferencesWindowController.h"

@interface WCLAppDelegate ()
@property (nonatomic, strong) WCLPreferencesWindowController *preferencesWindowController;
- (IBAction)showPreferencesWindow:(id)sender;
@end

@implementation WCLAppDelegate

+ (void)initialize
{
    if (self == [WCLAppDelegate class]) {
        NSURL *userDefaultsURL = [[NSBundle mainBundle] URLForResource:kUserDefaultsFilename
                                                         withExtension:kUserDefaultsFileExtension];
        NSDictionary *userDefaultsDictionary = [NSDictionary dictionaryWithContentsOfURL:userDefaultsURL];
        [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDictionary];
        [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:userDefaultsDictionary];
        
        // TODO: This disables caching application wide. It would be nice to replace
        // this with a more granular approach.
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                             diskCapacity:0
                                                                 diskPath:nil];
        [NSURLCache setSharedURLCache:URLCache];
    }
}


#pragma mark Termination

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    if ([WCLApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks]) return NSTerminateNow;
    
    return NSTerminateLater;
}


#pragma mark Preferences

- (IBAction)showPreferencesWindow:(id)sender
{
    [self.preferencesWindowController showWindow:self];
}

- (WCLPreferencesWindowController *)preferencesWindowController
{
    if (_preferencesWindowController) return _preferencesWindowController;
    
    self.preferencesWindowController = [[WCLPreferencesWindowController alloc] initWithWindowNibName:kPreferencesWindowControllerNibName];
    
    return _preferencesWindowController;
}

@end
