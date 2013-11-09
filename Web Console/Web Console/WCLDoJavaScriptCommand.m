//
//  DoJavaScriptCommand.m
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLDoJavaScriptCommand.h"

#import "WCLWebWindowsController.h"
#import "WCLWebWindowController.h"

@implementation WCLDoJavaScriptCommand

- (id)performDefaultImplementation {

    NSString *javaScript = [self directParameter];
        
	NSDictionary *argumentsDictionary = [self evaluatedArguments];
    NSWindow *window = [argumentsDictionary objectForKey:kAppleScriptTargetKey];
    
    WCLWebWindowController *webWindowController = (WCLWebWindowController *)window.windowController;

    return [webWindowController doJavaScript:javaScript];
}

@end
