//
//  TaskTestsHelper.m
//  Web Console
//
//  Created by Roben Kleene on 10/21/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "TaskTestsHelper.h"

#import "Web_ConsoleTestsConstants.h"

@implementation TaskTestsHelper

+ (void)blockUntilTaskFinishes:(NSTask *)task
{
    [self blockUntilTaskFinishes:task timeoutInterval:kTestTimeoutInterval];
}

+ (void)blockUntilTaskFinishes:(NSTask *)task timeoutInterval:(NSTimeInterval)timeoutInterval
{
    [self blockUntilTasksFinish:@[task] timeoutInterval:timeoutInterval];
}

+ (void)blockUntilTasksFinish:(NSArray *)tasks
{
    [self blockUntilTasksFinish:tasks timeoutInterval:kTestTimeoutInterval];
}

+ (void)blockUntilTasksFinish:(NSArray *)tasks timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSMutableArray *observers = [NSMutableArray array];
    for (NSTask *task in tasks) {
        if (![task isRunning]) continue;

        __block id observer;
        observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSTaskDidTerminateNotification
                                                                     object:task
                                                                      queue:nil
                                                                 usingBlock:^(NSNotification *notification) {
                                                                     [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                     [observers removeObject:observer];
                                                                 }];
        [observers addObject:observer];
    }

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeoutInterval];
    while ([observers count] && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }

    BOOL tasksFinished = ![observers count] ? YES : NO;
    
    for (id observer in observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }

    NSAssert(tasksFinished, @"The NSTasks should have finished.");
}

@end
