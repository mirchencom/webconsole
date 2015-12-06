//
//  WCLSplitWebWindowControllerTestCase.m
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLSplitWebWindowControllerTestCase.h"

#import "WCLSplitWebWindowControllerTestsHelper.h"
#import "WCLTaskTestsHelper.h"
#import "Web_Console-Swift.h"
#import "WCLTaskRunner.h"
#import "WCLWebViewController.h"
#import "XCTestCase+UserDefaults.h"

#pragma mark - DefaultWebView

@interface WCLWebViewController (DefaultWebView)
@property (readonly) WebView *webView;
@end

@interface SplitWebViewController (DefaultWebView)
@property (readonly) WCLWebViewController *defaultWebViewController;
@end

@implementation WCLSplitWebWindowController (DefaultWebView)
- (WebView *)defaultWebView
{
    SplitWebViewController *splitWebViewController = (SplitWebViewController *)self.contentViewController;
    return splitWebViewController.defaultWebViewController.webView;
}
@end

@interface WCLWebViewController (Plugin)
@property (nonatomic, strong, readwrite, nullable) Plugin *plugin;
@end


#pragma mark - WCLSplitWebWindowControllerTestCase

@implementation WCLSplitWebWindowControllerTestCase

- (void)setUp
{
    [super setUp];
    [self setUpMockUserDefaults];
}

- (void)tearDown
{
    [WCLSplitWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    [self tearDownMockUserDefaults];
    [super tearDown];
}

#pragma mark - Running Tasks

- (NSTask *)taskRunningCommandPath:(NSString *)commandPath
{
    NSTask *task;
    (void)[self splitWebWindowControllerRunningCommandPath:commandPath task:&task];
    return task;
}

+ (void)blockUntilAllTasksRunAndFinish
{
    // Clean up
    NSArray *tasks = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] tasks];
    [WCLTaskTestsHelper blockUntilTasksRunAndFinish:tasks];
}

- (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath
{
    return [self splitWebWindowControllerRunningCommandPath:commandPath plugin:nil task:nil];
}

- (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath plugin:(Plugin *)plugin
{
    return [self splitWebWindowControllerRunningCommandPath:commandPath plugin:plugin task:nil];
}

- (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath task:(NSTask **)task
{
    return [self splitWebWindowControllerRunningCommandPath:commandPath plugin:nil task:task];
}

- (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath
                                                                     plugin:(Plugin *)plugin
                                                                       task:(NSTask **)task
{
    WCLSplitWebWindowController *splitWebWindowController = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] addedSplitWebWindowController];
    WCLWebViewController *webViewController = splitWebWindowController.splitWebViewController.defaultWebViewController;
    webViewController.plugin = plugin;
    NSAssert(splitWebWindowController.plugin == plugin, @"The WCLSplitWebWindowController's WCLPlugin should equal the WCLPlugin.");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Running task"];
    NSTask *runningTask = [WCLTaskRunner runTaskWithCommandPath:commandPath
                            withArguments:nil
                          inDirectoryPath:nil
                                 delegate:webViewController
                        completionHandler:^(BOOL success)
     {
         XCTAssertTrue(success, @"Running the NSTask should succeed.");
         [expectation fulfill];
     }];
    [self waitForExpectationsWithTimeout:kTestTimeoutInterval handler:nil];

    if (task) {
        *task = runningTask;
    }
    
    return splitWebWindowController;
}

+ (Plugin *)defaultPlugin
{
    return [[PluginsManager sharedInstance] pluginWithName:kTestCatPluginName];
}

+ (Plugin *)otherPlugin
{
    return [[PluginsManager sharedInstance] pluginWithName:kTestHelloWorldPluginName];
}

- (WCLSplitWebWindowController *)makeSplitWebWindowController
{
    Plugin *plugin = [[self class] defaultPlugin];
    return [self makeSplitWebWindowControllerRunningHelloWorldForPlugin:plugin];
}

- (WCLSplitWebWindowController *)makeSplitWebWindowControllerForOtherPlugin
{
    Plugin *plugin = [[self class] otherPlugin];
    return [self makeSplitWebWindowControllerRunningHelloWorldForPlugin:plugin];
}

- (WCLSplitWebWindowController *)makeSplitWebWindowControllerRunningHelloWorldForPlugin:(Plugin *)plugin
{
    // The plugin needs a name for saved frames to work
    XCTAssertNotNil(plugin.name, @"The WCLPlugin should have a name.");
    
    WCLSplitWebWindowController *splitWebWindowController = [self splitWebWindowControllerRunningHelloWorldForPlugin:plugin];
    [WCLSplitWebWindowControllerTestsHelper blockUntilWindowIsVisible:splitWebWindowController.window];
    return splitWebWindowController;
}

- (WCLSplitWebWindowController *)splitWebWindowControllerRunningHelloWorldForPlugin:(Plugin *)plugin
{
    // Run a simple command to get the window to display
    NSString *commandPath = [self wcl_pathForResource:kTestDataRubyHelloWorld
                                               ofType:kTestDataRubyExtension
                                         subdirectory:kTestDataSubdirectory];
    return [self splitWebWindowControllerRunningCommandPath:commandPath plugin:plugin];
}

- (WCLSplitWebWindowController *)makeSplitWebWindowControllerForPlugin:(Plugin *)plugin
{
    WCLSplitWebWindowController *splitWebWindowController = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] addedSplitWebWindowController];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Running task"];
    [splitWebWindowController runPlugin:plugin withArguments:nil inDirectoryPath:nil completionHandler:^(BOOL success) {
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:kTestTimeoutInterval handler:nil];
    
    [WCLSplitWebWindowControllerTestsHelper blockUntilWindowIsVisible:splitWebWindowController.window];
    
    return splitWebWindowController;
}


@end
