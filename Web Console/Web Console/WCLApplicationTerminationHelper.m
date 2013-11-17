//
//  ApplicationTerminationHelper.m
//  Web Console
//
//  Created by Roben Kleene on 9/8/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLApplicationTerminationHelper.h"

#import "WCLWebWindowsController.h"
#import "WCLWebWindowController.h"

@interface WCLApplicationTerminationHelper ()
+ (NSMutableArray *)webWindowControllersWithTasks;
@end

@implementation WCLApplicationTerminationHelper

+ (NSArray *)webWindowControllersWithTasks
{
    NSPredicate *tasksPredicate = [NSPredicate predicateWithFormat:@"hasTasks == %@", [NSNumber numberWithBool:YES]];
    return [[[WCLWebWindowsController sharedWebWindowsController] webWindowControllers] filteredArrayUsingPredicate:tasksPredicate];
}

+ (BOOL)applicationShouldTerminateAndManageWebWindowControllersWithTasks
{
    NSMutableArray *webWindowControllersWithTasks = [WCLApplicationTerminationHelper webWindowControllersWithTasks];
    
    if (![webWindowControllersWithTasks count]) return YES;

    NSMutableArray *windowWillCloseObservers = [NSMutableArray array];

    void (^replyToApplicationShouldTerminate)(BOOL shouldCancel) = ^(BOOL shouldCancel) {
        if (shouldCancel) {
            [NSApp replyToApplicationShouldTerminate:NO];
            for (id windowWillCloseObserver in windowWillCloseObservers) {
                [[NSNotificationCenter defaultCenter] removeObserver:windowWillCloseObserver];
            }
        } else {
            if (![windowWillCloseObservers count] &&
                ![[WCLApplicationTerminationHelper webWindowControllersWithTasks] count]) {
                [NSApp replyToApplicationShouldTerminate:YES];
            }
        }
    };

    // Quit if the user closes all the windows with running tasks
    for (WCLWebWindowController *webWindowController in webWindowControllersWithTasks) {
        __block id windowWillCloseObserver;
        windowWillCloseObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification
                                                                     object:webWindowController.window
                                                                      queue:nil
                                                                 usingBlock:^(NSNotification *notification) {
                                                                     [[NSNotificationCenter defaultCenter] removeObserver:windowWillCloseObserver];
                                                                     [windowWillCloseObservers removeObject:windowWillCloseObserver];
                                                                     replyToApplicationShouldTerminate(NO);
                                                                 }];
        [windowWillCloseObservers addObject:windowWillCloseObserver];
        [webWindowController.window performClose:self];
    }

    // Cancel the quit if the user does not confirm closing a window with a running task
    __block id cancelWindowCloseObserver;
    cancelWindowCloseObserver= [[NSNotificationCenter defaultCenter] addObserverForName:WCLWebWindowControllerDidCancelCloseWindowNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      [[NSNotificationCenter defaultCenter] removeObserver:cancelWindowCloseObserver];
                                                      replyToApplicationShouldTerminate(YES);
                                                  }];
 
    // Cancel the quit after a timeout
    double delayInSeconds = kApplicationTerminationTimeout;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        replyToApplicationShouldTerminate(YES);
    });
    
    return NO;
}

@end
