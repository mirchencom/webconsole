//
//  TaskHelper.m
//  Web Console
//
//  Created by Roben Kleene on 7/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "TaskHelper.h"
#import "NSTask+Termination.h"

@implementation TaskHelper

+ (void)terminateTasks:(NSArray *)tasks completionHandler:(void (^)(BOOL success))completionHandler
{
    NSMutableArray *mutableTasks = [NSMutableArray arrayWithArray:tasks];
    __block BOOL tasksTerminated = NO;
    
    void (^completionHandlerBlock)() = ^void () {
        if (![mutableTasks count]) {
            tasksTerminated = YES;
            completionHandler(YES);
        }
    };
    
#warning Change to mutable tasks to tasks after unit tests are written
    for (NSTask *task in mutableTasks) {
        [task interruptWithCompletionHandler:^(BOOL success) {
            if (!success) {
                DLog(@"Failed to interrupt a task, trying terminate");
                [task terminateWithCompletionHandler:^(BOOL success) {
                    NSAssert(success, @"Terminating should always succeed");
                    [mutableTasks removeObject:task];
                    completionHandlerBlock();
                }];
            } else {
                [mutableTasks removeObject:task];
                completionHandlerBlock();
            }
        }];
    }

    double delayInSeconds = kTaskInterruptTimeout * 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        if (!tasksTerminated) {
            completionHandler(NO);
        }
    });
}

@end
