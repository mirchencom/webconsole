//
//  WCLTestPluginManager.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Web_Console-Swift.h"

@interface WCLPluginManagerTests : XCTestCase

@end

@implementation WCLPluginManagerTests

// TODO: Migrate this to PluginsManagerTests

//- (void)testLoadPlugins
//{
//    // Don't use the shared plugin manager, because it will already have plugins
//    // loaded.
//    WCLPluginManager *pluginManager = [[WCLPluginManager alloc] init];
//    [pluginManager loadPlugins];
//
//    NSUInteger pluginCount = [[pluginManager plugins] count];
//    
//    NSUInteger testPluginCount = 0;
//    NSArray *pluginsPaths = [WCLPluginManager pluginsPaths];
//    for (NSString *plugInsPath in pluginsPaths) {
//        NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:plugInsPath error:nil];
//        NSString *pluginFileExtension = [NSString stringWithFormat:@".%@", kPlugInExtension];
//        NSPredicate *pluginFileExtensionPredicate = [NSPredicate predicateWithFormat:@"self ENDSWITH %@", pluginFileExtension];
//        NSArray *pluginPathComponents = [paths filteredArrayUsingPredicate:pluginFileExtensionPredicate];
//        
//        for (NSString *pluginPathComponent in pluginPathComponents) {
//            NSString *pluginPath = [plugInsPath stringByAppendingPathComponent:pluginPathComponent];
//            WCLPlugin *plugin = [[WCLPlugin alloc] initWithPath:pluginPath];
//            if (plugin) {
//                testPluginCount++;
//            }
//        }
//    }
//    
//    XCTAssertEqual(pluginCount, testPluginCount, @"The plugin count should equal the test plugin count.");
//}

@end
