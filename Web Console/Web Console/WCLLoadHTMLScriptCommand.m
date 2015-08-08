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

    WCLSplitWebWindowController *webWindowController;
    if (window) {
        webWindowController = (WCLSplitWebWindowController *)window.windowController;
    } else {
        webWindowController = [[WCLSplitWebWindowsController sharedWebWindowsController] addedWebWindowController];
        window = webWindowController.window;
    }

    [self suspendExecution];
    [webWindowController loadHTML:HTML baseURL:baseURL completionHandler:^(BOOL success) {
        [self resumeExecutionWithResult:window];
    }];
    
    return nil;
}

@end
