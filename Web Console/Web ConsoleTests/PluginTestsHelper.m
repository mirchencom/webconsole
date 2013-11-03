//
//  PluginTestsHelper.m
//  Web Console
//
//  Created by Roben Kleene on 10/21/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "PluginTestsHelper.h"

#import "Web_ConsoleTestsConstants.h"

@implementation PluginTestsHelper

+ (void)blockUntilTaskFinishes:(NSTask *)task
{
    [self blockUntilTaskFinishes:task timeoutInterval:kTestTimeoutInterval];
}

+ (void)blockUntilTaskFinishes:(NSTask *)task timeoutInterval:(NSTimeInterval)timeoutInterval
{
    if (![task isRunning]) return;
    
    __block id observer;
    __block BOOL taskDidFinish = NO;
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSTaskDidTerminateNotification
                                                                 object:task
                                                                  queue:nil
                                                             usingBlock:^(NSNotification *notification) {
                                                                 [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                 taskDidFinish = YES;
                                                             }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeoutInterval];
    while (!taskDidFinish && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    
    NSAssert(taskDidFinish, @"The task should have finished");
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
                                                                     NSLog(@"a task finished");
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

    NSAssert(tasksFinished, @"Tasks should have finished");
}

@end
