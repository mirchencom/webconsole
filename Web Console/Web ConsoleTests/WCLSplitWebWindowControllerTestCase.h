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

@interface WCLSplitWebWindowController (Tests)
- (void)terminateTasksAndCloseWindow;
@end

@interface WCLSplitWebWindowController (PluginWebView)
@property (nonatomic, readonly) WebView *pluginWebView;
@end

@interface WCLSplitWebWindowControllerTestCase : WCLTestPluginManagerTestCase
+ (Plugin *)defaultPlugin;
- (WCLSplitWebWindowController *)makeSplitWebWindowController;
+ (NSTask *)taskRunningCommandPath:(NSString *)commandPath;
+ (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath;
+ (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath task:(NSTask **)task;
@end
