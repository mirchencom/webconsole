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

NS_ASSUME_NONNULL_BEGIN
@interface WCLSplitWebWindowController (Tests)
- (void)terminateTasksAndCloseWindow;
@property (nonatomic, readonly) SplitWebViewController *splitWebViewController;
- ( NSArray *)commandsRequiringConfirmation;
- ( NSArray *)commandsNotRequiringConfirmation;
@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface WCLSplitWebWindowController (DefaultWebView)
@property (nonatomic, readonly) WebView *defaultWebView;
@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface WCLSplitWebWindowControllerTestCase : WCLTestPluginManagerTestCase
+ (Plugin *)defaultPlugin;
+ (Plugin *)otherPlugin;
- (WCLSplitWebWindowController *)makeSplitWebWindowControllerRunningHelloWorldForPlugin:(Plugin *)plugin;
- (WCLSplitWebWindowController *)makeSplitWebWindowControllerForPlugin:(Plugin *)plugin;
- (WCLSplitWebWindowController *)makeSplitWebWindowController;
- (WCLSplitWebWindowController *)makeSplitWebWindowControllerForOtherPlugin;
- (NSTask *)taskRunningCommandPath:(NSString *)commandPath;
- (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath;
- (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath
                                                                       task:(nullable NSTask *)task;
- (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath
                                                                     plugin:(nullable Plugin *)plugin
                                                                       task:(nullable NSTask *)task;
+ (void)blockUntilAllTasksRunAndFinish;
@end
NS_ASSUME_NONNULL_END
