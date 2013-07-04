//
//  DoJavaScriptCommand.m
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "DoJavaScriptCommand.h"

#import "WebWindowsController.h"
#import "WebWindowController.h"

@implementation DoJavaScriptCommand

- (id)performDefaultImplementation {

    NSString *javaScript = [self directParameter];
        
	NSDictionary *argumentsDictionary = [self evaluatedArguments];
    NSWindow *window = [argumentsDictionary objectForKey:kAppleScriptTargetKey];
    
    WebWindowController *webWindowController = (WebWindowController *)window.windowController;

    return [webWindowController doJavaScript:javaScript];
}

@end
