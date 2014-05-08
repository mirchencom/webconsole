//
//  WCLPluginManager+LoadingPlugins.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import "WCLPluginManager.h"

@interface WCLPluginManager (LoadingPlugins)

/*! Loads WCLPlugins from all locations.
 */
- (void)loadPlugins;

@end