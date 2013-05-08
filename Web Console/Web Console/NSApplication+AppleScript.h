//
//  NSApplication+AppleScript.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSApplication (AppleScript)
-(void)loadHTML:(NSScriptCommand *)command;
@end
