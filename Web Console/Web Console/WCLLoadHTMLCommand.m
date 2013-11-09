//
//  LoadHTMLCommand.m
//  Web Console
//
//  Created by Roben Kleene on 6/17/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLLoadHTMLCommand.h"

#import "WCLWebWindowsController.h"
#import "WCLWebWindowController.h"

#define kFileURLPrefix @"file://"

@implementation WCLLoadHTMLCommand

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

    WCLWebWindowController *webWindowController;
    if (window) {
        webWindowController = (WCLWebWindowController *)window.windowController;
    } else {
        webWindowController = [[WCLWebWindowsController sharedWebWindowsController] addedWebWindowController];
        window = webWindowController.window;
    }

    [self suspendExecution];
    [webWindowController loadHTML:HTML baseURL:baseURL completionHandler:^(BOOL success) {
        [self resumeExecutionWithResult:window];
    }];
    
    return nil;
}

@end
