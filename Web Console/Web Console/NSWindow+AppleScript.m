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

#pragma mark - WCLPluginView

- (void)loadHTML:(nonnull NSString *)HTML
         baseURL:(nullable NSURL *)baseURL
completionHandler:(nullable void (^)(BOOL success))completionHandler
{
}

- (nullable NSString *)doJavaScript:(nonnull NSString *)javaScript
{
    WCLSplitWebWindowController *splitWebWindowController = (WCLSplitWebWindowController *)self.windowController;
    return [splitWebWindowController doJavaScript:javaScript];
}

@end
