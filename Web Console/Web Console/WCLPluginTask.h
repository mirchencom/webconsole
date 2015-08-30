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
- (void)pluginTaskWillStart:(NSTask *)task;
- (void)pluginTaskDidFinish:(NSTask *)task;
- (NSDictionary *)environmentDictionaryForPluginTask:(NSTask *)task;
@end

@interface WCLPluginTask : NSObject
+ (void)runTask:(NSTask *)task delegate:(id<WCLPluginTaskDelegate>)delegate completionHandler:(void (^)(BOOL success))completionHandler;
@end