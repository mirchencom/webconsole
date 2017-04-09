//
//  NSWindow+AppleScript.m
//  Web Console
//
//  Created by Roben Kleene on 8/23/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import "NSWindow+AppleScript.h"
#import "WCLSplitWebWindowController.h"
#import "WCLSplitWebWindowsController.h"

@implementation NSWindow (AppleScript)

#pragma mark - WCLSplitWebWindowController

- (WCLSplitWebWindowController *)splitWebWindowController
{
    return (WCLSplitWebWindowController *)self.windowController;
}

#pragma mark - Log

- (void)handleShowLogScriptCommand:(NSScriptCommand *)command
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self splitWebWindowController] showLog];
    });
}

- (void)handleHideLogScriptCommand:(NSScriptCommand *)command
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self splitWebWindowController] hideLog];
    });
}

- (void)handleToggleLogScriptCommand:(NSScriptCommand *)command
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self splitWebWindowController] toggleLog];
    });
}

#pragma mark - Splits

- (nonnull NSArray<id <WCLPluginView>> *)splits
{
    return (NSArray<id <WCLPluginView>> *)[self.splitWebWindowController webViewControllers];
}

#pragma mark - WCLPluginView

- (void)loadHTML:(NSString *)HTML
         baseURL:(NSURL *)baseURL
completionHandler:(void (^)(BOOL success))completionHandler
{
    [[self splitWebWindowController] loadHTML:HTML
                                      baseURL:baseURL
                            completionHandler:completionHandler];
}

- (NSString *)doJavaScript:(nonnull NSString *)javaScript
{
    return [[self splitWebWindowController] doJavaScript:javaScript];
}

- (void)readFromStandardInput:(nonnull NSString *)text
{
    [[self splitWebWindowController] readFromStandardInput:text];
}

- (void)runPlugin:(nonnull Plugin *)plugin
    withArguments:(nullable NSArray *)arguments
  inDirectoryPath:(nullable NSString *)directoryPath
completionHandler:(nullable void (^)(BOOL))completionHandler
{
    [[self splitWebWindowController] runPlugin:plugin
                                 withArguments:arguments
                               inDirectoryPath:directoryPath
                             completionHandler:completionHandler];
}

@end
