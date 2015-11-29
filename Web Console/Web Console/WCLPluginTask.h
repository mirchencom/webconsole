//
//  WCLPluginTask.h
//  Web Console
//
//  Created by Roben Kleene on 1/11/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCLPluginTask;

@protocol WCLPluginTaskDelegate <NSObject>
@optional
- (void)pluginTaskWillStart:(nonnull NSTask *)task;
- (void)pluginTaskDidFinish:(nonnull NSTask *)task;
- (void)pluginTask:(nonnull NSTask *)task didReadFromStandardError:(nonnull NSString *)text;
- (void)pluginTask:(nonnull NSTask *)task didReadFromStandardOutput:(nonnull NSString *)text;
- (void)pluginTask:(nonnull NSTask *)task didFailToRunCommandPath:(nonnull NSString *)commandPath
             error:(nonnull NSError *)error;
- (void)pluginTask:(nonnull NSTask *)task didRunCommandPath:(nonnull NSString *)commandPath
         arguments:(nullable NSArray<NSString *> *)arguments
     directoryPath:(nullable NSString *)directoryPath;
- (nullable NSDictionary *)environmentDictionaryForPluginTask:(nonnull NSTask *)task;
@end

@interface WCLPluginTask : NSObject
+ (nonnull NSTask *)runTaskWithCommandPath:(nonnull NSString *)commandPath
                 withArguments:(nullable NSArray *)arguments
               inDirectoryPath:(nullable NSString *)directoryPath
                      delegate:(nullable id<WCLPluginTaskDelegate>)delegate
             completionHandler:(nullable void (^)(BOOL success))completionHandler;
@end