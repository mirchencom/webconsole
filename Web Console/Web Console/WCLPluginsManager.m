//
//  PluginManager.m
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLPluginsManager.h"
#import "Web_Console-Swift.h"

@implementation WCLPluginsManager

@synthesize defaultNewPlugin = _defaultNewPlugin;

- (instancetype)initWithPlugins:(NSArray *)plugins
{
    self = [super init];
    if (self) {
        _pluginsController = [[MultiCollectionController alloc] init:plugins key:kPluginNameKey];
    }
    return self;
}

- (Plugin *)defaultNewPlugin
{
    if (_defaultNewPlugin) {
        return _defaultNewPlugin;
    }
    
    NSString *identifier = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultNewPluginIdentifierKey];
    
    Plugin *plugin;
    
    if (identifier) {
        plugin = [self pluginWithIdentifier:identifier];
    }
    
    _defaultNewPlugin = plugin;
    
    return _defaultNewPlugin;
}

- (void)setDefaultNewPlugin:(Plugin *)defaultNewPlugin
{
    if (self.defaultNewPlugin == defaultNewPlugin) {
        return;
    }
    
    if (!defaultNewPlugin) {
        // Do this early so that the subsequent calls to the getter don't reset the default new plugin
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultNewPluginIdentifierKey];
    }
    
    Plugin *oldDefaultNewPlugin = _defaultNewPlugin;
    _defaultNewPlugin = defaultNewPlugin;
    
    oldDefaultNewPlugin.defaultNewPlugin = NO;
    
    _defaultNewPlugin.defaultNewPlugin = YES;
    
    if (_defaultNewPlugin) {
        [[NSUserDefaults standardUserDefaults] setObject:_defaultNewPlugin.identifier
                                                  forKey:kDefaultNewPluginIdentifierKey];
    }
}

- (Plugin *)pluginWithIdentifier:(NSString *)identifier
{
    NSAssert(NO, @"Implemented in superclass");
    return nil;
}

#pragma mark Required Key-Value Coding To-Many Relationship Compliance

- (NSArray *)plugins
{
    return [self.pluginsController objects];
}

- (void)insertObject:(Plugin *)plugin inPluginsAtIndex:(NSUInteger)index
{
    [self.pluginsController insertObject:plugin inObjectsAtIndex:index];
}

- (void)insertPlugins:(NSArray *)pluginsArray atIndexes:(NSIndexSet *)indexes
{
    [self.pluginsController insertObjects:pluginsArray atIndexes:indexes];
}

- (void)removeObjectFromPluginsAtIndex:(NSUInteger)index
{
    [self.pluginsController removeObjectFromObjectsAtIndex:index];
}

- (void)removePluginsAtIndexes:(NSIndexSet *)indexes
{
    [self.pluginsController removeObjectsAtIndexes:indexes];
}



// TODO: Implement
// #define kSharedResourcesPluginName @"Shared Resources"
//- (NSString *)sharedResourcesPath
//{
//    return [[self pluginWithName:kSharedResourcesPluginName] resourcePath];
//}
//
//- (NSURL *)sharedResourcesURL
//{
//    return [[self pluginWithName:kSharedResourcesPluginName] resourceURL];
//}

@end
