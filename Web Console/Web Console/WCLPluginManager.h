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

/*! Returns a shared singleton WCLPluginManager object.
 */
+ (id)sharedPluginManager;

/*! Loads built-in WCLPlugins.
 */
- (void)loadPlugins;

/*! Returns the WCLPlugin with name, or nil if no Plugin with that name exists.
 * \param name The name of the Plugin to return.
 * \returns The WCLPlugin with name.
 */
- (WCLPlugin *)pluginWithName:(NSString *)name;

/*! Returns an array of WCLPlugin objects.
 * \returns An array of WCLPlugin objects.
 */
- (NSArray *)plugins;

/*! Returns the WCLPlugin at the specified URL, or nil if no valid Plugin exists at that URL.
 * \param URL The URL of the Plugin to add.
 * \returns The WCLPlugin at the specified URL.
 */
- (WCLPlugin *)addedPluginAtURL:(NSURL *)URL;

/*! Returns the full URL of the Shared Resource WCLPlugin’s resource directory.
 * \returns The full URL of the Shared Resource WCLPlugin’s resource directory.
 */
- (NSURL *)sharedResourceURL;

/*! Returns the full pathname of the Shared Resource WCLPlugin’s resource directory.
 * \returns The full pathname of the Shared Resource WCLPlugin’s resource directory.
 */
- (NSString *)sharedResourcePath;

@end