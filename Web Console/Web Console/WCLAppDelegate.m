//
//  AppDelegate.m
//  Web Console
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLAppDelegate.h"

#import "WCLPluginManager.h"

#import "WCLWebWindowsController.h"

#import "WCLTaskHelper.h"

#import "WCLApplicationTerminationHelper.h"

@implementation WCLAppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [[WCLPluginManager sharedPluginManager] loadPlugins];
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    if ([WCLApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks]) return NSTerminateNow;
    
    return NSTerminateLater;
}

@end
