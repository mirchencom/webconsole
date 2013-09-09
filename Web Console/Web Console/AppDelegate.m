//
//  AppDelegate.m
//  Web Console
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "AppDelegate.h"

#import "PluginManager.h"

#import "WebWindowsController.h"

#import "TaskHelper.h"

#import "ApplicationTerminationHelper.h"

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [[PluginManager sharedPluginManager] loadPlugins];
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    if ([ApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks]) return NSTerminateNow;
    
    return NSTerminateLater;

}

@end
