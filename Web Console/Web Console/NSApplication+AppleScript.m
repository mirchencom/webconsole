//
//  NSApplication+AppleScript.m
//  Web Console
//
//  Created by Roben Kleene on 7/14/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "NSApplication+AppleScript.h"

#import "Web_Console-Swift.h"

@implementation NSApplication (AppleScript)

- (NSArray *)plugins
{
    return [[PluginsManager sharedInstance] plugins];
}

// TODO: Implement
//- (id)handleLoadPluginScriptCommand:(NSScriptCommand *)command
//{
//    NSURL *pluginFileURL = [command directParameter];
//
//    return [[PluginsManager sharedInstance] addedPluginAtURL:pluginFileURL];
//}


@end
