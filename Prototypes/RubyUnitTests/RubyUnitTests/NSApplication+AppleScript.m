//
//  NSApplication+ScriptingExample.m
//  ScriptingExample
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "NSApplication+AppleScript.h"

@implementation NSApplication (AppleScript)

- (NSNumber*) ready {
    
    /* output to the log */
    NSLog(@"returning application's ready property");
	
    /* return always ready */
	return [NSNumber numberWithBool:YES];
}

@end
