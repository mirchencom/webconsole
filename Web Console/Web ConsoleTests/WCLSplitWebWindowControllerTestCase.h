//
//  WCLSplitWebWindowControllerTestCase.h
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <WebKit/WebKit.h>

#import "XCTest+BundleResources.h"

#import "Web_ConsoleTestsConstants.h"

#import "WCLSplitWebWindowsController.h"
#import "WCLSplitWebWindowController.h"
#import "WCLTestPluginManagerTestCase.h"

@class SplitWebViewController;

@interface WCLSplitWebWindowController (Tests)
- (void)terminateTasksAndCloseWindow;
@property (nonatomic, readonly) SplitWebViewController *splitWebViewController;
@end

@interface WCLSplitWebWindowController (DefaultWebView)
@property (nonatomic, readonly) WebView *defaultWebView;
@end

@interface WCLSplitWebWindowControllerTestCase : WCLTestPluginManagerTestCase
+ (Plugin *)defaultPlugin;
+ (Plugin *)otherPlugin;
- (WCLSplitWebWindowController *)makeSplitWebWindowController;
- (WCLSplitWebWindowController *)makeSplitWebWindowControllerForOtherPlugin;
- (NSTask *)taskRunningCommandPath:(NSString *)commandPath;
- (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath;
- (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath task:(NSTask **)task;
+ (void)blockUntilAllTasksRunAndFinish;
@end
