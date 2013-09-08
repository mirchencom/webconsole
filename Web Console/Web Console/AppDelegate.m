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

@implementation AppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [[PluginManager sharedPluginManager] loadPlugins];
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    NSArray *tasks = [[WebWindowsController sharedWebWindowsController] tasks];
    
    if (![tasks count]) return NSTerminateNow;
    
    [AppDelegate terminateTasksAndReplyToApplicationShouldTerminate:tasks];
    
    return NSTerminateLater;
}

+ (void)terminateTasksAndReplyToApplicationShouldTerminate:(NSArray *)tasks
{
    [TaskHelper terminateTasks:tasks completionHandler:^(BOOL sucess) {
        NSAssert(sucess, @"Terminating tasks should always succeed");
        NSArray *tasks = [[WebWindowsController sharedWebWindowsController] tasks];
        if(![tasks count]) {
            [NSApp replyToApplicationShouldTerminate:YES];
        } else {
            [AppDelegate terminateTasksAndReplyToApplicationShouldTerminate:tasks];
        }
    }];
}

@end
