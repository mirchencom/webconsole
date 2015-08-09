//
//  DoJavaScriptCommand.m
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLDoJavaScriptCommand.h"

#import "WCLSplitWebWindowsController.h"
#import "WCLSplitWebWindowController.h"

@implementation WCLDoJavaScriptCommand

- (id)performDefaultImplementation
{

    NSString *javaScript = [self directParameter];
        
	NSDictionary *argumentsDictionary = [self evaluatedArguments];
    NSWindow *window = [argumentsDictionary objectForKey:kAppleScriptTargetKey];
    
    WCLSplitWebWindowController *splitWebWindowController = (WCLSplitWebWindowController *)window.windowController;

    return [splitWebWindowController doJavaScript:javaScript];
}

@end
