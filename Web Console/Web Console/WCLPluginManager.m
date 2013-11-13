//
//  PluginManager.m
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLPluginManager.h"
#import "WCLPlugin.h"

#define kPlugInExtension @"bundle"

@interface WCLPluginManager ()
@property (nonatomic, strong) NSMutableDictionary *nameToPluginDictionary;
- (void)loadPluginsInDirectory:(NSString *)plugInsPath;
- (WCLPlugin *)addedPluginWithPath:(NSString *)path;
@end

@implementation WCLPluginManager

+ (id)sharedPluginManager
{
    static dispatch_once_t pred;
    static WCLPluginManager *pluginManager = nil;
    
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
        (void)[[WCLPluginManager sharedPluginManager] addedPluginWithPath:path];
    }
}

- (WCLPlugin *)addedPluginAtURL:(NSURL *)URL
{
    return [self addedPluginWithPath:[URL path]];
}

- (WCLPlugin *)addedPluginWithPath:(NSString *)path
{
    WCLPlugin *plugin = [[WCLPlugin alloc] initWithPath:path];

    if (!plugin) return nil;
    
    // TODO: This allows a new plugin with the same name to replace the old plugin. Is this what I want?
    self.nameToPluginDictionary[plugin.name] = plugin;

    return plugin;
}

- (WCLPlugin *)pluginWithName:(NSString *)name
{
    return self.nameToPluginDictionary[name];
}

- (NSArray *)plugins {
    return [self.nameToPluginDictionary allValues];
}

@end
