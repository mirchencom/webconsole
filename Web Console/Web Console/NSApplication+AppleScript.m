//
//  NSApplication+AppleScript.m
//  Web Console
//
//  Created by Roben Kleene on 7/14/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "NSApplication+AppleScript.h"

#import "Web_Console-Swift.h"
#import "WCLAppleScriptPluginWrapper.h"

@implementation NSApplication (AppleScript)

- (NSArray *)plugins
{
    NSArray *plugins = [[PluginsManager sharedInstance] plugins];

    NSMutableArray *pluginWrappers = [NSMutableArray array];
    for (Plugin *plugin in plugins) {
        WCLAppleScriptPluginWrapper *pluginWrapper = [[WCLAppleScriptPluginWrapper alloc] initWithPlugin:plugin];
        [pluginWrappers addObject:pluginWrapper];
    }
    return [pluginWrappers copy];
}

- (id)handleLoadPluginScriptCommand:(NSScriptCommand *)command
{
    NSURL *pluginFileURL = [command directParameter];

    Plugin *plugin = [Plugin pluginWithURL:pluginFileURL];
    
    [[PluginsManager sharedInstance] addUnwatchedPlugin:plugin];
    
    return [[WCLAppleScriptPluginWrapper alloc] initWithPlugin:plugin];
}

@end
