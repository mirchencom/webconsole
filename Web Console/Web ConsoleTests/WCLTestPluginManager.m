//
//  WCLTestPluginManager.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WCLPluginManager.h"
#import "WCLPluginManager+LoadingPlugins.h"

@interface WCLTestPluginManager : XCTestCase

@end

@interface WCLPluginManager ()
+ (NSArray *)pluginsPaths;
@end

@implementation WCLTestPluginManager

- (void)testLoadPlugins
{
    // Don't use the shared plugin manager, because it will already have plugins
    // loaded.
    WCLPluginManager *pluginManager = [[WCLPluginManager alloc] init];
    
    // TODO: Should match the count of objects with the plugin extension

    NSArray *pluginsPaths = [WCLPluginManager pluginsPaths];
    
}

@end
