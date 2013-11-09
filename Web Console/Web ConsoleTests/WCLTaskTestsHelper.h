//
//  TaskTestsHelper.h
//  Web Console
//
//  Created by Roben Kleene on 10/21/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCLTaskTestsHelper : NSObject
+ (void)blockUntilTaskFinishes:(NSTask *)task;
+ (void)blockUntilTaskFinishes:(NSTask *)task timeoutInterval:(NSTimeInterval)timeoutInterval;
+ (void)blockUntilTasksFinish:(NSArray *)tasks;
+ (void)blockUntilTasksFinish:(NSArray *)tasks timeoutInterval:(NSTimeInterval)timeoutInterval;
@end
