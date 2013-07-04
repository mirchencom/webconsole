//
//  LoadHTMLCommand.m
//  Web Console
//
//  Created by Roben Kleene on 6/17/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "LoadHTMLCommand.h"

#import "WebWindowsController.h"
#import "WebWindowController.h"

#define kFileURLPrefix @"file://"

@implementation LoadHTMLCommand

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

    WebWindowController *webWindowController;
    if (window) {
        webWindowController = (WebWindowController *)window.windowController;
    } else {
        webWindowController = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];
        window = webWindowController.window;
    }

    [self suspendExecution];
    [webWindowController loadHTML:HTML baseURL:baseURL completionHandler:^(BOOL success) {
        [self resumeExecutionWithResult:window];
    }];
    
    return nil;
}

@end
