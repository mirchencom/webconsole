//
//  AppDelegate.m
//  PluginTest
//
//  Created by Roben Kleene on 7/2/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "AppDelegate.h"

#import "PluginManager.h"
#import "Plugin.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[PluginManager sharedPluginManager] loadPlugins];
    Plugin *plugin = [[PluginManager sharedPluginManager] pluginWithName:@"Example"];

    
    [plugin run];
}

@end