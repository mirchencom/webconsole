//
//  LoadHTMLCommand.m
//  Web Console
//
//  Created by Roben Kleene on 6/17/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLLoadHTMLScriptCommand.h"

#import "WCLSplitWebWindowsController.h"
#import "WCLSplitWebWindowController.h"
#import "WCLPluginView.h"
#import "NSWindow+AppleScript.h"

#define kFileURLPrefix @"file://"

@implementation WCLLoadHTMLScriptCommand

- (id)performDefaultImplementation {

    NSString *HTML = [self directParameter];
    if (!HTML) {
        return nil;
    }

    NSDictionary *argumentsDictionary = [self evaluatedArguments];
    
    // Get the pluginView or make a new window if no target is specified
    id<WCLPluginView> pluginView = [argumentsDictionary objectForKey:kAppleScriptTargetKey];
    if (!pluginView) {
        WCLSplitWebWindowController *splitWebWindowController = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] addedSplitWebWindowController];
        pluginView = splitWebWindowController.window;
    }

    NSString *baseURLString = [argumentsDictionary objectForKey:kBaseURLKey];
    NSURL *baseURL;
    if ([baseURLString hasPrefix:kFileURLPrefix]) {
        baseURL = [NSURL fileURLWithPath:[baseURLString substringFromIndex:kFileURLPrefix.length - 1]];
    } else {
        baseURL = [NSURL URLWithString:baseURLString];
    }

    [self suspendExecution];
    [pluginView loadHTML:HTML baseURL:baseURL completionHandler:^(BOOL success) {
        [self resumeExecutionWithResult:pluginView];
    }];
    
    return nil;
}

@end
