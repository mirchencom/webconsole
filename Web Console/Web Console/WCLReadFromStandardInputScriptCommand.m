//
//  WCLReadFromStandardInputCommand.m
//  Web Console
//
//  Created by Roben Kleene on 8/29/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import "WCLReadFromStandardInputScriptCommand.h"

#import "WCLPluginView.h"

@implementation WCLReadFromStandardInputScriptCommand

- (id)performDefaultImplementation {
    
    NSString *text = [self directParameter];
    if (!text) {
        return nil;
    }
    
    NSDictionary *argumentsDictionary = [self evaluatedArguments];
    id<WCLPluginView> pluginView = [argumentsDictionary objectForKey:kAppleScriptTargetKey];

    [pluginView readFromStandardInput:text];

    return nil;
}

@end
