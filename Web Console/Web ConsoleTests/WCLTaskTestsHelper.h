//
//  TaskTestsHelper.h
//  Web Console
//
//  Created by Roben Kleene on 10/21/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCLTaskTestsHelper : NSObject
#pragma mark - Running
+ (void)blockUntilTasksAreRunning:(NSArray *)tasks;
+ (void)blockUntilTaskIsRunning:(NSTask *)task;
#pragma mark - Finishing
+ (void)interruptTaskAndblockUntilTaskFinishes:(NSTask *)task;
+ (void)blockUntilTaskFinishes:(NSTask *)task;
+ (void)blockUntilTaskFinishes:(NSTask *)task timeoutInterval:(NSTimeInterval)timeoutInterval;
+ (void)blockUntilTasksFinish:(NSArray *)tasks;
+ (void)blockUntilTasksFinish:(NSArray *)tasks timeoutInterval:(NSTimeInterval)timeoutInterval;
#pragma mark - Running & Finishing
+ (void)blockUntilTasksRunAndFinish:(NSArray *)tasks;
@end
