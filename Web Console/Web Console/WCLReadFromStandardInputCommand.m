//
//  WCLReadFromStandardInputCommand.m
//  Web Console
//
//  Created by Roben Kleene on 8/29/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import "WCLReadFromStandardInputCommand.h"

#import "WCLPluginView.h"

@implementation WCLReadFromStandardInputCommand

- (id)performDefaultImplementation {
    
    NSString *text = [self directParameter];
    
    NSDictionary *argumentsDictionary = [self evaluatedArguments];
    id<WCLPluginView> pluginView = [argumentsDictionary objectForKey:kAppleScriptTargetKey];

    [pluginView readFromStandardInput:text];

    return nil;
}

@end
