//
//  NSApplication+AppleScript.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "NSApplication+AppleScript.h"

#import "WebWindowsController.h"

@implementation NSApplication (AppleScript)

-(void)loadHTML:(NSScriptCommand *)command {
    NSLog(@"The direct parameter is: '%@'", [command directParameter]);
    [[WebWindowsController sharedWebWindowsController] addWebWindowWithHTML:[command directParameter]];
}

@end
