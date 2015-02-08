//
//  AppDelegate.m
//  Web Console
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLAppDelegate.h"

#import "WCLWebWindowsController.h"

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
    NSURL *userDefaultsURL = [[NSBundle mainBundle] URLForResource:kUserDefaultsFilename
                                                     withExtension:kUserDefaultsFileExtension];
    NSDictionary *userDefaultsDictionary = [NSDictionary dictionaryWithContentsOfURL:userDefaultsURL];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDictionary];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:userDefaultsDictionary];
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
