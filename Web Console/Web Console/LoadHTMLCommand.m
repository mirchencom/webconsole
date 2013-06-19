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
    
    if (window) {
        WebWindowController *webWindowController = (WebWindowController *)window.windowController;
        [webWindowController loadHTML:HTML];
    } else {
        WebWindowController *webWindowController = [[WebWindowsController sharedWebWindowsController] webWindowWithHTML:HTML];
        window = webWindowController.window;
    }

    return window;
}

@end
