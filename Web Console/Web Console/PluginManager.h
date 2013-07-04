//
//  PluginManager.h
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Plugin;

@interface PluginManager : NSObject
+ (id)sharedPluginManager;
- (void)loadPlugins;
- (Plugin *)addedPluginWithPath:(NSString *)path;
- (Plugin *)pluginWithName:(NSString *)name;
@end