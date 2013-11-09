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
- (NSArray *)wcl_plugins;

@end