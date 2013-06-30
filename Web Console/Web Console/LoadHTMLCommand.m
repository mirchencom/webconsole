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

@implementation LoadHTMLCommand

- (id)performDefaultImplementation {
	NSDictionary *argumentsDictionary = [self evaluatedArguments];

    NSString *HTML = [self directParameter];
    
    NSWindow *window = [argumentsDictionary objectForKey:kAppleScriptTargetKey];
    
    WebWindowController *webWindowController;
    if (window) {
        webWindowController = (WebWindowController *)window.windowController;
    } else {
        webWindowController = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];
        window = webWindowController.window;
    }

    [self suspendExecution];
    [webWindowController loadHTML:HTML completionHandler:^(BOOL success) {
        [self resumeExecutionWithResult:window];
    }];
    
    return nil;
}

@end
