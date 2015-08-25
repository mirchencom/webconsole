//
//  WebWindowController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "WCLPluginView.h"

@class Plugin;
@class WCLSplitWebWindowController;
@class SplitWebViewController;

extern NSString * __nonnull const WCLSplitWebWindowControllerDidCancelCloseWindowNotification;

@protocol WCLSplitWebWindowControllerDelegate <NSObject>
@optional
- (void)splitWebWindowControllerWindowWillClose:(nonnull WCLSplitWebWindowController *)splitWebWindowController;
@end

@interface WCLSplitWebWindowController : NSWindowController <WCLPluginView>
@property (nonatomic, weak, nullable) id<WCLSplitWebWindowControllerDelegate> delegate;
@property (nonatomic, strong, nullable) Plugin *plugin;
@property (nonnull, readonly) SplitWebViewController *splitWebViewController;
#pragma mark - AppleScript
- (nonnull NSArray *)webViewControllers;
#pragma mark - Tasks
- (void)runTask:(nonnull NSTask *)task;
- (BOOL)hasTasks;
- (nonnull NSArray *)tasks;
@end