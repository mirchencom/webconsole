//
//  WCLSplitWebWindowControllerTestCase.h
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <WebKit/WebKit.h>

#import "XCTestCase+BundleResources.h"

#import "Web_ConsoleTestsConstants.h"

#import "WCLSplitWebWindowsController.h"
#import "WCLSplitWebWindowController.h"
#import "WCLTestPluginManagerTestCase.h"

@class SplitWebViewController;

@interface WCLSplitWebWindowController (Tests)
- (void)terminateTasksAndCloseWindow;
@property (nonatomic, readonly, nonnull) SplitWebViewController *splitWebViewController;
- (nonnull NSArray *)commandsRequiringConfirmation;
- (nonnull NSArray *)commandsNotRequiringConfirmation;
@end

@interface WCLSplitWebWindowController (DefaultWebView)
@property (nonatomic, readonly, nonnull) WebView *defaultWebView;
@end

@interface WCLSplitWebWindowControllerTestCase : WCLTestPluginManagerTestCase
+ (nonnull Plugin *)defaultPlugin;
+ (nonnull Plugin *)otherPlugin;
- (nonnull WCLSplitWebWindowController *)makeSplitWebWindowControllerRunningHelloWorldForPlugin:(nonnull Plugin *)plugin;
- (nonnull WCLSplitWebWindowController *)makeSplitWebWindowControllerForPlugin:(nonnull Plugin *)plugin;
- (nonnull WCLSplitWebWindowController *)makeSplitWebWindowController;
- (nonnull WCLSplitWebWindowController *)makeSplitWebWindowControllerForOtherPlugin;
- (nonnull NSTask *)taskRunningCommandPath:(nonnull NSString *)commandPath;
- (nonnull WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(nonnull NSString *)commandPath;
- (nonnull WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(nonnull NSString *)commandPath
                                                                               task:(NSTask * _Nullable * _Nullable)task;
- (nonnull WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(nonnull NSString *)commandPath
                                                                             plugin:(nullable Plugin *)plugin
                                                                               task:(NSTask * _Nullable * _Nullable)task;
+ (void)blockUntilAllTasksRunAndFinish;
@end
