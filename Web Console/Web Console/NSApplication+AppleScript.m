//
//  NSApplication+AppleScript.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "NSApplication+AppleScript.h"

#import "WebWindowController.h"

@implementation NSApplication (AppleScript)

-(void)loadHTML:(NSScriptCommand *)command {
    
    NSLog(@"The direct parameter is: '%@'", [command directParameter]);

	WebWindowController *webWindowController = [[WebWindowController alloc] initWithWindowNibName:@"WebWindow"];
	[webWindowController showWindow:self];

    NSLog(@"webWindowController = %@", webWindowController);
}

@end
