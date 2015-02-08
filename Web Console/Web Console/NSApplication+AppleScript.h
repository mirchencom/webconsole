//
//  NSApplication+AppleScript.h
//  Web Console
//
//  Created by Roben Kleene on 7/14/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSApplication (AppleScript)

#pragma mark - AppleScript
// This property should be called wcl_plugins, based on Apple's recommendation
// that methods in categories on framework classes should use a prefix, but the
// script dictionary "plugins" element on the application broke when it was
// renamed. This did not work, the plugins were being returned but without there
// class being defined.
// <element type="plugin" access="r"><cocoa key="wcl_plugins"/></element>
- (NSArray *)plugins;
//- (id)handleLoadPluginScriptCommand:(NSScriptCommand *)command;
@end