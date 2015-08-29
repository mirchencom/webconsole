//
//  DoJavaScriptCommand.m
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLDoJavaScriptCommand.h"

#import "WCLPluginView.h"

@implementation WCLDoJavaScriptCommand

- (id)performDefaultImplementation
{
    NSString *javaScript = [self directParameter];
    if (!javaScript) {
        return nil;
    }
    
	NSDictionary *argumentsDictionary = [self evaluatedArguments];
    id<WCLPluginView> pluginView = [argumentsDictionary objectForKey:kAppleScriptTargetKey];
    return [pluginView doJavaScript:javaScript];
}

@end
