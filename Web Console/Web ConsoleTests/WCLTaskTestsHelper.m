//
//  TaskTestsHelper.m
//  Web Console
//
//  Created by Roben Kleene on 10/21/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLTaskTestsHelper.h"

#import "Web_ConsoleTestsConstants.h"

#import "NSTask+Termination.h"

@implementation WCLTaskTestsHelper

#pragma mark - Running

+ (void)blockUntilTasksAreRunning:(NSArray *)tasks
{
    __block NSMutableArray *tasksWaitingToRun = [tasks mutableCopy];
    
    // Tasks can start and finish between run loop checks, so remove them on termination
    __block NSMutableArray *observers = [NSMutableArray array];
    for (NSTask *task in tasks) {
        __block id observer;
        observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSTaskDidTerminateNotification
                                                                     object:task
                                                                      queue:nil
                                                                 usingBlock:^(NSNotification *notification) {
                                                                     [tasksWaitingToRun removeObject:task];
                                                                     [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                     [observers removeObject:observer];
                                                                 }];
        [observers addObject:observer];
    }
    
    // Poll whether tasks are running until the count of tasks waiting to run is zero (or the timeout occurs)
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while ([tasksWaitingToRun count] && [loopUntil timeIntervalSinceNow] > 0) {
        NSMutableArray *tasksNowRunning = [NSMutableArray array];
        for (NSTask *task in tasksWaitingToRun) {
            if ([task isRunning]) {
                [tasksNowRunning addObject:task];
            }
        }
        [tasksWaitingToRun removeObjectsInArray:tasksNowRunning];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    
    for (id observer in observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    
    NSAssert(![tasksWaitingToRun count], @"All of the NSTasks should have started running.");
}


#pragma mark - Finishing

+ (void)interruptTaskAndblockUntilTaskFinishes:(NSTask *)task
{
    __block BOOL completionHandlerRan = NO;
    [task wcl_interruptWithCompletionHandler:^(BOOL success) {
        NSAssert(success, @"The interrupted should have succeeded.");
        completionHandlerRan = YES;
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!completionHandlerRan && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    NSAssert(completionHandlerRan, @"The completion handler should have run.");
    NSAssert(![task isRunning], @"The NSTask should not be running.");
}

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
    __block NSMutableArray *observers = [NSMutableArray array];
    for (NSTask *task in tasks) {
        if (![task isRunning]) {
            continue;
        }

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

#pragma mark - Running & Finishing

+ (void)blockUntilTasksRunAndFinish:(NSArray *)tasks
{
    [WCLTaskTestsHelper blockUntilTasksAreRunning:tasks];
    [WCLTaskTestsHelper blockUntilTasksFinish:tasks];
}

@end
