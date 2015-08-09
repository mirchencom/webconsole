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

#define kFileURLPrefix @"file://"

@implementation WCLLoadHTMLScriptCommand

- (id)performDefaultImplementation {

    NSString *HTML = [self directParameter];

    NSDictionary *argumentsDictionary = [self evaluatedArguments];
    NSWindow *window = [argumentsDictionary objectForKey:kAppleScriptTargetKey];
    NSString *baseURLString = [argumentsDictionary objectForKey:kBaseURLKey];
    
    NSURL *baseURL;
    if ([baseURLString hasPrefix:kFileURLPrefix]) {
        baseURL = [NSURL fileURLWithPath:[baseURLString substringFromIndex:kFileURLPrefix.length - 1]];
    } else {
        baseURL = [NSURL URLWithString:baseURLString];
    }

    WCLSplitWebWindowController *splitWebWindowController;
    if (window) {
        splitWebWindowController = (WCLSplitWebWindowController *)window.windowController;
    } else {
        splitWebWindowController = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] addedSplitWebWindowController];
        window = splitWebWindowController.window;
    }

    [self suspendExecution];
    [splitWebWindowController loadHTML:HTML baseURL:baseURL completionHandler:^(BOOL success) {
        [self resumeExecutionWithResult:window];
    }];
    
    return nil;
}

@end
