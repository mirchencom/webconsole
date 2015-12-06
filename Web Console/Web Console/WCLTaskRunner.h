//
//  WCLTaskRunner.h
//  Web Console
//
//  Created by Roben Kleene on 1/11/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCLTaskRunner;

@protocol WCLTaskRunnerDelegate <NSObject>
@optional
#pragma mark Starting & Finishing Tasks
- (void)taskWillStart:(nonnull NSTask *)task;
- (void)taskDidFinish:(nonnull NSTask *)task;
- (void)task:(nonnull NSTask *)task didFailToRunCommandPath:(nonnull NSString *)commandPath
             error:(nonnull NSError *)error;
#pragma mark Events
- (void)task:(nonnull NSTask *)task didReadFromStandardError:(nonnull NSString *)text;
- (void)task:(nonnull NSTask *)task didReadFromStandardOutput:(nonnull NSString *)text;
- (void)task:(nonnull NSTask *)task didRunCommandPath:(nonnull NSString *)commandPath
         arguments:(nullable NSArray<NSString *> *)arguments
     directoryPath:(nullable NSString *)directoryPath;
#pragma mark Data Source
- (nullable NSDictionary *)environmentDictionaryForPluginTask:(nonnull NSTask *)task;
@end

@interface WCLTaskRunner : NSObject
+ (nonnull NSTask *)runTaskWithCommandPath:(nonnull NSString *)commandPath
                 withArguments:(nullable NSArray *)arguments
               inDirectoryPath:(nullable NSString *)directoryPath
                      delegate:(nullable id<WCLTaskRunnerDelegate>)delegate
             completionHandler:(nullable void (^)(BOOL success))completionHandler;
@end