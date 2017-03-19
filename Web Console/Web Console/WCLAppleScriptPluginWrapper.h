//
//  WCLAppleScriptPluginWrapper.h
//  Web Console
//
//  Created by Roben Kleene on 2/9/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Plugin;

NS_ASSUME_NONNULL_BEGIN
@interface WCLAppleScriptPluginWrapper : NSObject
- (instancetype)initWithPlugin:(Plugin *)plugin;
- (NSString *)name;
- (nullable NSString *)resourcePath;
- (nullable NSString *)resourceURLString;
- (NSArray *)orderedWindows;
@end
NS_ASSUME_NONNULL_END
