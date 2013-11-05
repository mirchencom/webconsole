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

@interface ApplicationTerminationHelper ()
+ (NSMutableArray *)webWindowControllersWithTasks;
@end

@implementation ApplicationTerminationHelper

+ (NSArray *)webWindowControllersWithTasks
{
    NSPredicate *tasksPredicate = [NSPredicate predicateWithFormat:@"hasTasks == %@", [NSNumber numberWithBool:YES]];
    return [[[WebWindowsController sharedWebWindowsController] webWindowControllers] filteredArrayUsingPredicate:tasksPredicate];
}

+ (BOOL)applicationShouldTerminateAndManageWebWindowControllersWithTasks
{
    NSMutableArray *webWindowControllersWithTasks = [ApplicationTerminationHelper webWindowControllersWithTasks];
    
    if (![webWindowControllersWithTasks count]) return YES;

    NSMutableArray *webWindowControllersWaitingToClose = [webWindowControllersWithTasks mutableCopy];
    NSMutableArray *observers = [NSMutableArray array];
    __block BOOL windowsDidFinishClosing = NO;
    for (WebWindowController *webWindowController in webWindowControllersWithTasks) {
#warning After tests are setup, move perform close after adding observer
        [webWindowController.window performClose:self];
        __block id observer;
        observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification
                                                                     object:webWindowController.window
                                                                      queue:nil
                                                                 usingBlock:^(NSNotification *notification) {
                                                                     [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                     [observers removeObject:observer];
#warning After tests are setup, refactor to just use observers count
                                                                     [webWindowControllersWaitingToClose removeObject:webWindowController];
                                                                     if (![webWindowControllersWaitingToClose count] &&
                                                                         ![[ApplicationTerminationHelper webWindowControllersWithTasks] count]) {
                                                                         [NSApp replyToApplicationShouldTerminate:YES];
                                                                         windowsDidFinishClosing = YES;
                                                                     }
                                                                 }];
        [observers addObject:observer];
    }
    
    double delayInSeconds = kApplicationTerminationTimeout;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        if (!windowsDidFinishClosing) {
            [NSApp replyToApplicationShouldTerminate:NO];
            for (id observer in observers) {
                [[NSNotificationCenter defaultCenter] removeObserver:observer];
            }
        }
    });
    
    return NO;
}

@end
