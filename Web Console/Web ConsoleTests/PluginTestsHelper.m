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

@end
