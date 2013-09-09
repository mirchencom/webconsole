//
//  ApplicationTerminationHelper.m
//  Web Console
//
//  Created by Roben Kleene on 9/8/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "ApplicationTerminationHelper.h"

#import "WebWindowsController.h"
#import "WebWindowController.h"

@implementation ApplicationTerminationHelper

+ (NSMutableArray *)webWindowControllersWithTasks
{
    NSMutableArray *webWindowControllersWithTasks = [[[WebWindowsController sharedWebWindowsController] webWindowControllers] mutableCopy];
    
    NSPredicate *tasksPredicate = [NSPredicate predicateWithFormat:@"hasTasks == YES"];
    [webWindowControllersWithTasks filteredArrayUsingPredicate:tasksPredicate];
    
    return webWindowControllersWithTasks;
}

+ (BOOL)applicationShouldTerminateAndManageWebWindowControllersWithTasks
{
    NSMutableArray *webWindowControllersWithTasks = [ApplicationTerminationHelper webWindowControllersWithTasks];
    
    if (![webWindowControllersWithTasks count]) return YES;

    NSMutableArray *webWindowControllersWaitingToClose = [webWindowControllersWithTasks mutableCopy];
    NSMutableArray *activeObservers = [NSMutableArray array];
    __block BOOL didReply = NO;
    for (WebWindowController *webWindowController in webWindowControllersWithTasks) {
        [webWindowController.window performClose:self];
        __block id observer;
        observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification
                                                                     object:webWindowController.window
                                                                      queue:nil
                                                                 usingBlock:^(NSNotification *notification) {
                                                                     [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                     [activeObservers removeObject:observer];
                                                                     [webWindowControllersWaitingToClose removeObject:webWindowController];
                                                                     if (![webWindowControllersWaitingToClose count] &&
                                                                         ![[ApplicationTerminationHelper webWindowControllersWithTasks] count]) {
                                                                         [NSApp replyToApplicationShouldTerminate:YES];
                                                                         didReply = YES;
                                                                     }
                                                                 }];
        [activeObservers addObject:observer];
    }
    
    double delayInSeconds = kApplicationTerminationTimeout;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        if (!didReply) {
            [NSApp replyToApplicationShouldTerminate:NO];
            for (id observer in activeObservers) {
                [[NSNotificationCenter defaultCenter] removeObserver:observer];
            }
        }
    });
    
    return NO;
}

@end