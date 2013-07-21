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

@interface AppDelegate ()
- (NSArray *)tasks;
@end

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [[PluginManager sharedPluginManager] loadPlugins];
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    NSLog(@"shouldTerminate");

    NSArray *tasks = [[WebWindowsController sharedWebWindowsController] tasks];
    if (![tasks count]) return NSTerminateNow;
    
    return NSTerminateNow;
}


- (NSArray *)tasks {
    [[WebWindowsController sharedWebWindowsController] tasks];
    
    return nil;
}

@end
