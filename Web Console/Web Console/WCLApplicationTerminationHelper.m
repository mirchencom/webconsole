//
//  ApplicationTerminationHelper.m
//  Web Console
//
//  Created by Roben Kleene on 9/8/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLApplicationTerminationHelper.h"

#import "WCLSplitWebWindowsController.h"
#import "WCLSplitWebWindowController.h"

@interface WCLApplicationTerminationHelper ()
+ (NSMutableArray *)splitWebWindowControllersWithTasks;
@end

@implementation WCLApplicationTerminationHelper

+ (NSArray *)splitWebWindowControllersWithTasks
{
    NSPredicate *tasksPredicate = [NSPredicate predicateWithFormat:@"hasTasks == %@", [NSNumber numberWithBool:YES]];
    return [[[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllers] filteredArrayUsingPredicate:tasksPredicate];
}

+ (BOOL)applicationShouldTerminateAndManageWebWindowControllersWithTasks
{
    NSMutableArray *splitWebWindowControllersWithTasks = [WCLApplicationTerminationHelper splitWebWindowControllersWithTasks];
    
    if (![splitWebWindowControllersWithTasks count]) return YES;

    NSMutableArray *windowWillCloseObservers = [NSMutableArray array];

    void (^replyToApplicationShouldTerminate)(BOOL shouldCancel) = ^(BOOL shouldCancel) {
        if (shouldCancel) {
            [NSApp replyToApplicationShouldTerminate:NO];
            for (id windowWillCloseObserver in windowWillCloseObservers) {
                [[NSNotificationCenter defaultCenter] removeObserver:windowWillCloseObserver];
            }
        } else {
            if (![windowWillCloseObservers count]) {
                // The application should only terminate if there are no NSTasks. This condition can be false if a new NSTask
                // started after user initialized the quit.
                BOOL shouldTerminate = [[WCLApplicationTerminationHelper splitWebWindowControllersWithTasks] count] ? NO : YES;
                [NSApp replyToApplicationShouldTerminate:shouldTerminate];
            }
        }
    };

    // Quit if the user closes all the windows with running tasks
    for (WCLSplitWebWindowController *splitWebWindowController in splitWebWindowControllersWithTasks) {
        __block id windowWillCloseObserver;
        windowWillCloseObserver = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification
                                                                     object:splitWebWindowController.window
                                                                      queue:nil
                                                                 usingBlock:^(NSNotification *notification) {
                                                                     [[NSNotificationCenter defaultCenter] removeObserver:windowWillCloseObserver];
                                                                     [windowWillCloseObservers removeObject:windowWillCloseObserver];
                                                                     replyToApplicationShouldTerminate(NO);
                                                                 }];
        [windowWillCloseObservers addObject:windowWillCloseObserver];
        [splitWebWindowController.window performClose:self];
    }

    // Cancel the quit if the user does not confirm closing a window with a running task
    __block id cancelWindowCloseObserver;
    cancelWindowCloseObserver= [[NSNotificationCenter defaultCenter] addObserverForName:WCLSplitWebWindowControllerDidCancelCloseWindowNotification
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
