//
//  WCLAppleScriptPluginWrapper.h
//  Web Console
//
//  Created by Roben Kleene on 2/9/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Plugin;

@interface WCLAppleScriptPluginWrapper : NSObject
- (instancetype)initWithPlugin:(Plugin *)plugin;
- (NSString *)name;
- (NSString *)resourcePath;
- (NSString *)resourceURLString;
- (NSArray *)orderedWindows;
@end
