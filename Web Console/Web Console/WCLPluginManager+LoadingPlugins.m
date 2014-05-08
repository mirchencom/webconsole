//
//  WCLPluginManager+LoadingPlugins.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import "WCLPluginManager+LoadingPlugins.h"

@implementation WCLPluginManager (LoadingPlugins)

- (void)loadPlugins
{
    NSArray *pluginsPaths = [WCLPluginManager pluginsPaths];
    for (NSString *pluginsPath in pluginsPaths) {
        [self loadPluginsInDirectory:pluginsPath];
    }
}

- (void)loadPluginsInDirectory:(NSString *)plugInsPath
{
    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:plugInsPath error:nil];
    NSString *pluginFileExtension = [NSString stringWithFormat:@".%@", kPlugInExtension];
    NSPredicate *pluginFileExtensionPredicate = [NSPredicate predicateWithFormat:@"self ENDSWITH %@", pluginFileExtension];

    NSArray *pluginPathComponents = [paths filteredArrayUsingPredicate:pluginFileExtensionPredicate];

    for (NSString *pluginPathComponent in pluginPathComponents) {
        NSString *pluginPath = [plugInsPath stringByAppendingPathComponent:pluginPathComponent];
        (void)[[WCLPluginManager sharedPluginManager] addedPluginWithPath:pluginPath];
    }
}

+ (NSArray *)pluginsPaths
{
    // Allow path construction methods to return nil
    NSArray *pluginsPaths = @[[self builtInPluginsPath] ? : [NSNull null],
                              [self applicationSupportPluginsPath] ? : [NSNull null]];
    NSMutableArray *mutablePluginsPaths = [pluginsPaths mutableCopy];
    [mutablePluginsPaths removeObjectIdenticalTo:[NSNull null]];
    return [NSArray arrayWithArray:mutablePluginsPaths];
}

+ (NSString *)builtInPluginsPath
{
    return [[NSBundle mainBundle] builtInPlugInsPath];
}

+ (NSString *)applicationSupportPluginsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportPath = [paths firstObject];
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    return [[applicationSupportPath stringByAppendingPathComponent:applicationName] stringByAppendingPathComponent:kPlugInsPathComponent];
}

@end
