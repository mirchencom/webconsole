//
//  PluginTests.m
//  Web Console
//
//  Created by Roben Kleene on 7/6/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "PluginTests.h"

#import "Web_ConsoleTestsConstants.h"
#import "SenTestCase+BundleResources.h"
#import "Plugin.h"
#import "PluginManager.h"

@interface PluginManager (TestingAdditions)
- (void)loadPluginsInDirectory:(NSString *)plugInsPath;
@end

@implementation PluginTests

- (void)setUp
{
    [super setUp];

    NSString *builtInPlugInsPath = [[NSBundle bundleForClass:[self class]] builtInPlugInsPath];

    [[PluginManager sharedPluginManager] loadPluginsInDirectory:builtInPlugInsPath];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

// Test plugins are loaded

- (void)testPluginsLoaded
{
    NSArray *pluginNames = kAllPlugins;
    for (NSString *pluginName in pluginNames) {
        Plugin *plugin = [[PluginManager sharedPluginManager] pluginWithName:pluginName];
        NSString *errorMessage = [NSString stringWithFormat:@"Plugin should be loaded %@", pluginName];
        STAssertNotNil(plugin, errorMessage);
    }
}

- (void)testTestNoWindow
{
    Plugin *testNoWindowPlugin = [[PluginManager sharedPluginManager] pluginWithName:@"TestNoWindow"];

    Plugin *testNoWindowPlugin2 = [[PluginManager sharedPluginManager] pluginWithName:@"TestNoWindow"];
    
    
    [testNoWindowPlugin runWithArguments:nil inDirectoryPath:nil];


    
    [testNoWindowPlugin2 runWithArguments:nil inDirectoryPath:nil];

    // TODO: Analyze windows here
    
    
    NSLog(@"Break");

    // TODO: When the tasks finish, the window should be removed
}


- (void)testTestWindow
{
    Plugin *testWindowPlugin = [[PluginManager sharedPluginManager] pluginWithName:@"TestWindow"];
    
    Plugin *testWindowPlugin2 = [[PluginManager sharedPluginManager] pluginWithName:@"TestWindow"];
    
    
    [testWindowPlugin runWithArguments:nil inDirectoryPath:nil];
    
    
    
    [testWindowPlugin2 runWithArguments:nil inDirectoryPath:nil];
    
    // TODO: Analyze windows here
    
    
    NSLog(@"Break");
    
    // TODO: When the tasks finish, the window should be removed
}
@end
