//
//  PluginManager.m
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLPluginManager.h"
#import "WCLPlugin.h"

@interface WCLPluginManager ()
@property (nonatomic, strong) NSMutableDictionary *nameToPluginDictionary;
@end

@implementation WCLPluginManager

+ (id)sharedPluginManager
{
    static dispatch_once_t pred;
    static WCLPluginManager *pluginManager = nil;
    
    dispatch_once(&pred, ^{ pluginManager = [[self alloc] init]; });
    return pluginManager;
}

#pragma mark - Properties

- (NSMutableDictionary *)nameToPluginDictionary
{
    if (_nameToPluginDictionary) {
        return _nameToPluginDictionary;
    }
    
    _nameToPluginDictionary = [[NSMutableDictionary alloc] init];
    
    return _nameToPluginDictionary;
}

#pragma mark - WCLPlugins

- (WCLPlugin *)addedPluginAtURL:(NSURL *)URL
{
    return [self addedPluginWithPath:[URL path]];
}

- (WCLPlugin *)addedPluginWithPath:(NSString *)path
{
    WCLPlugin *plugin = [[WCLPlugin alloc] initWithPath:path];

    if (!plugin) {
        return nil;
    }
    
    // TODO: This allows a new plugin with the same name to replace the old plugin. Is this what I want?
    // Probably yes, this allows the plugin to by modified
    self.nameToPluginDictionary[plugin.name] = plugin;

    return plugin;
}

- (WCLPlugin *)pluginWithName:(NSString *)name
{
    return self.nameToPluginDictionary[name];
}

- (NSArray *)plugins
{
    return [self.nameToPluginDictionary allValues];
}

- (NSString *)sharedResourcesPath
{
    return [[self pluginWithName:kSharedResourcesPluginName] resourcePath];
}

- (NSURL *)sharedResourcesURL
{
    return [[self pluginWithName:kSharedResourcesPluginName] resourceURL];
}

@end
