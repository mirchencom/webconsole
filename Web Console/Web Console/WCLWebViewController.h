//
//  WCLWebViewController.h
//  Web Console
//
//  Created by Roben Kleene on 8/7/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "WCLPluginView.h"
#import "WCLPluginTask.h"

@class Plugin;
@class WCLWebViewController;

@protocol WCLWebViewControllerDelegate <NSObject>
- (nonnull NSWindow *)windowForWebViewController:(nonnull WCLWebViewController *)webViewController;
@optional
- (void)webViewControllerViewWillAppear:(nonnull WCLWebViewController *)webViewController;
- (void)webViewControllerViewWillDisappear:(nonnull WCLWebViewController *)webViewController;
- (void)webViewControllerWillLoadHTML:(nonnull WCLWebViewController *)webViewController;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController didReceiveTitle:(nonnull NSString *)title;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController taskWillStart:(nonnull NSTask *)task;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController taskDidFinish:(nonnull NSTask *)task;
@end

@interface WCLWebViewController : NSViewController <WCLPluginTaskDelegate, WCLPluginView>
- (BOOL)hasTasks;
@property (nonatomic, strong, readonly, nonnull) NSArray *tasks;
@property (nonatomic, strong, nullable) Plugin *plugin;
@property (nonatomic, weak, nullable) id<WCLWebViewControllerDelegate> delegate;
#pragma mark - AppleScript
@property (nonatomic, strong, readonly, nonnull) NSString *identifier;
@end
