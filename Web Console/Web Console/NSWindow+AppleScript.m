//
//  NSWindow+AppleScript.m
//  Web Console
//
//  Created by Roben Kleene on 8/23/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import "NSWindow+AppleScript.h"
#import "WCLSplitWebWindowController.h"

@implementation NSWindow (AppleScript)

- (NSArray *)views
{
    WCLSplitWebWindowController *splitWebViewController = (WCLSplitWebWindowController *)self.windowController;
    return splitWebViewController.webViewControllers;
}

@end
