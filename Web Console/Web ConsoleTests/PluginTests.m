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

- (void)testNoWindowTestPlugin
{
    Plugin *noWindowTestPlugin = [[PluginManager sharedPluginManager] pluginWithName:@"NoWindowTest"];

    [noWindowTestPlugin runWithArguments:nil inDirectoryPath:nil];
}

@end
