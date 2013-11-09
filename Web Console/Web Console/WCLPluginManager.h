//
//  PluginManager.h
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCLPlugin;

@interface WCLPluginManager : NSObject

/*! Returns a shared singleton PluginManager object.
 */
+ (id)sharedPluginManager;

/*! Loads built-in Plugins.
 */
- (void)loadPlugins;

/*! Returns the Plugin with name, or nil if no Plugin with that name exists.
 * \param name The name of the Plugin to return.
 * \returns The Plugin with name.
 */
- (WCLPlugin *)pluginWithName:(NSString *)name;

/*! Returns an array of Plugin objects.
 * \returns An array of Plugin objects.
 */
- (NSArray *)plugins;

@end