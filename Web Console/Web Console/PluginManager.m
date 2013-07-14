//
//  PluginManager.m
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "PluginManager.h"
#import "Plugin.h"

#define kPlugInExtension @"bundle"

@interface PluginManager ()
@property (nonatomic, strong) NSMutableDictionary *nameToPluginDictionary;
- (void)loadPluginsInDirectory:(NSString *)plugInsPath;
@end

@implementation PluginManager

+ (id)sharedPluginManager
{
    static dispatch_once_t pred;
    static PluginManager *pluginManager = nil;
    
    dispatch_once(&pred, ^{ pluginManager = [[self alloc] init]; });
    return pluginManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _nameToPluginDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)loadPlugins
{
    NSString *builtInPlugInsPath = [[NSBundle mainBundle] builtInPlugInsPath];
    [self loadPluginsInDirectory:builtInPlugInsPath];
//    NSArray *bundlePaths = [NSBundle pathsForResourcesOfType:kPlugInExtension inDirectory:builtInPlugInsPath];
//    
//    for (NSString *path in bundlePaths) {
//        (void)[[PluginManager sharedPluginManager] addedPluginWithPath:path];
//    }
}

- (void)loadPluginsInDirectory:(NSString *)plugInsPath
{
    NSArray *bundlePaths = [NSBundle pathsForResourcesOfType:kPlugInExtension inDirectory:plugInsPath];
    
    for (NSString *path in bundlePaths) {
        (void)[[PluginManager sharedPluginManager] addedPluginWithPath:path];
    }
}

- (Plugin *)addedPluginWithPath:(NSString *)path
{
    Plugin *plugin = [[Plugin alloc] initWithPath:path];

    if (!plugin) return nil;
    
    // Allow only one plugin with a name
    if (self.nameToPluginDictionary[plugin.name]) return nil;
    
    self.nameToPluginDictionary[plugin.name] = plugin;
    
    return plugin;
}

- (Plugin *)pluginWithName:(NSString *)name
{
    return self.nameToPluginDictionary[name];
}

- (NSArray *)plugins {
    return [self.nameToPluginDictionary allValues];
}

@end
