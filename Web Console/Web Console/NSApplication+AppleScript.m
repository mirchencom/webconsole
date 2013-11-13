//
//  NSApplication+AppleScript.m
//  Web Console
//
//  Created by Roben Kleene on 7/14/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "NSApplication+AppleScript.h"

#import "WCLPluginManager.h"

@implementation NSApplication (AppleScript)

- (NSArray *)plugins
{    
    return [[WCLPluginManager sharedPluginManager] plugins];
}

- (id)handleLoadPluginScriptCommand:(NSScriptCommand *)command
{
    id directParameter = [command directParameter];
    NSLog(@"directParameter = %@", directParameter);
    
    return nil;
}


@end
