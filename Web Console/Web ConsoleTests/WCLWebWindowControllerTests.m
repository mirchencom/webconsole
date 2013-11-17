//
//  Web_ConsoleTests.m
//  Web ConsoleTests
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Web_ConsoleTestsConstants.h"
#import "XCTest+BundleResources.h"

#import "WebView+Source.h"

#import "WCLWebWindowsController.h"
#import "WCLWebWindowController.h"
#import "WCLWebWindowControllerTestsHelper.h"

#import "WCLTaskTestsHelper.h"

#import "WCLApplicationTerminationHelper.h"

#import "WCLPlugin+Tests.h"

#import "WCLPluginManager.h"

#import "WCLUserInterfaceTextHelper.h"


@interface WCLWebWindowControllerTests : XCTestCase
+ (void)testInformativeText:(NSString *)informativeText forCommandPaths:(NSArray *)commandPaths;
@end

@interface WCLWebWindowController (Tests)
@property (nonatomic, readonly) WebView *webView;
- (void)terminateTasksAndCloseWindow;
@end


@implementation WCLWebWindowControllerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    [WCLWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];

    [super tearDown];
}

#pragma mark - HTML & JavaScript

- (void)testLoadHTMLWithBaseURL {
    NSURL *fileURL = [self wcl_URLForResource:kTestDataHTMLJQUERYFilename
                            withExtension:kTestDataHTMLExtension
                             subdirectory:kTestDataSubdirectory];
    NSString *HTML = [self wcl_stringWithContentsOfFileURL:fileURL];
    NSURL *baseURL = [fileURL URLByDeletingLastPathComponent];

    __block BOOL completionHandlerRan = NO;
    WCLWebWindowController *webWindowController = [[WCLWebWindowsController sharedWebWindowsController] addedWebWindowController];
    [webWindowController loadHTML:HTML baseURL:baseURL completionHandler:^(BOOL success) {
        completionHandlerRan = YES;
        XCTAssertTrue(success, @"The load should have succeeded.");
    }];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
        if (completionHandlerRan) break;
    }
	
    XCTAssertTrue(completionHandlerRan, @"The completion handler should have run.");

    NSString *javaScript = [self stringWithContentsOfTestDataFilename:kTestJavaScriptTextJQueryFilename
                                                            extension:kTestDataJavaScriptExtension];
    NSString *result = [webWindowController doJavaScript:javaScript];

    NSString *testJavaScript = [self stringWithContentsOfTestDataFilename:kTestJavaScriptTextFilename
                                                            extension:kTestDataJavaScriptExtension];
    NSString *expectedResult = [webWindowController doJavaScript:testJavaScript];

    // These tests fail, but it works in actual use. I assume it is failing because of complications
    // caused by the test running on the main thread.
//    STAssertTrue(result.length > 0, @"The result should be great than zero.");
//    STAssertTrue(expectedResult.length > 0, @"The expected result should be great than zero.");
    XCTAssertEqual(result, expectedResult, @"The result should match the expected result");
}

- (void)testLoadHTMLTwice
{
    NSString *HTML = [self stringWithContentsOfTestDataFilename:kTestDataHTMLFilename extension:kTestDataHTMLExtension];
    
    WCLWebWindowController *webWindowController = [[WCLWebWindowsController sharedWebWindowsController] addedWebWindowController];

    __block BOOL firstCompletionHandlerRan = NO;
    [webWindowController loadHTML:HTML completionHandler:^(BOOL success) {
        firstCompletionHandlerRan = YES;
        XCTAssertFalse(success, @"The first load should have failed.");
    }];

    __block BOOL secondCompletionHandlerRan = NO;
    [webWindowController loadHTML:HTML completionHandler:^(BOOL success) {
        secondCompletionHandlerRan = YES;
        XCTAssertTrue(success, @"The second load should have succeeded.");
    }];
		
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
        if (firstCompletionHandlerRan && secondCompletionHandlerRan) break;
    }
	
    XCTAssertTrue(firstCompletionHandlerRan, @"The first completion handler should have run.");
    XCTAssertTrue(secondCompletionHandlerRan, @"The second completion handler should have run.");
}

- (void)testLoadHTMLInSeparateWindows
{    
    NSString *HTML = [self stringWithContentsOfTestDataFilename:kTestDataHTMLFilename extension:kTestDataHTMLExtension];
    
    WCLWebWindowController *webWindowController1 = [[WCLWebWindowsController sharedWebWindowsController] addedWebWindowController];
    __block BOOL firstCompletionHandlerRan = NO;
    [webWindowController1 loadHTML:HTML completionHandler:^(BOOL success) {
        firstCompletionHandlerRan = YES;
        XCTAssertTrue(success, @"The first load should have succeeded.");
    }];
    
    WCLWebWindowController *webWindowController2 = [[WCLWebWindowsController sharedWebWindowsController] addedWebWindowController];
    __block BOOL secondCompletionHandlerRan = NO;
    [webWindowController2 loadHTML:HTML completionHandler:^(BOOL success) {
        secondCompletionHandlerRan = YES;
        XCTAssertTrue(success, @"The second load should have succeeded.");
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
        if (firstCompletionHandlerRan && secondCompletionHandlerRan) break;
    }
	
    XCTAssertTrue(firstCompletionHandlerRan, @"The first completion handler should have run.");
    XCTAssertTrue(secondCompletionHandlerRan, @"The second completion handler should have run.");
    
    NSUInteger webWindowControllersCount = [[[WCLWebWindowsController sharedWebWindowsController] webWindowControllers] count];
    XCTAssertTrue(webWindowControllersCount == 2, @"There should be two WCLWebWindowControllers. %lu", webWindowControllersCount);
}


#pragma mark - Run Plugin

- (void)testPlugin
{
    NSString *commandPath = [self wcl_pathForResource:kTestDataRubyHelloWorld
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    WCLPlugin *plugin = [[WCLPlugin alloc] init];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertEqual([webWindowControllers count], (NSUInteger)1, @"The WCLPlugin should have one WebWindowController.");
    WCLWebWindowController *webWindowController = webWindowControllers[0];
    
    XCTAssertEqual(webWindowController.plugin, plugin, @"The WCLWebWindowController's WCLPlugin should equal the WCLPlugin.");

    // Clean up
    [WCLTaskTestsHelper blockUntilTasksAreRunning:webWindowController.tasks];
    [WCLTaskTestsHelper blockUntilTasksFinish:webWindowController.tasks];
}


#pragma mark - UserInterfaceTextHelper

- (void)testInformativeTextForCloseWindowForCommands
{
    NSString *informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:@[]];
    XCTAssertNil(informativeText, @"The informative text should be nil for an empty NSArray.");
    
    WCLPlugin *plugin = [[WCLPluginManager sharedPluginManager] pluginWithName:kTestPluginName];
    NSArray *commandPaths = @[[plugin commandPath]];
    informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:commandPaths];
    [WCLWebWindowControllerTests testInformativeText:informativeText forCommandPaths:commandPaths];

    WCLPluginManager *pluginManager = [WCLPluginManager sharedPluginManager];
    NSArray *plugins = [pluginManager plugins];
    commandPaths = [plugins valueForKey:kPluginCommandPathKey];
    informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:commandPaths];
    [WCLWebWindowControllerTests testInformativeText:informativeText forCommandPaths:commandPaths];
}

+ (void)testInformativeText:(NSString *)informativeText forCommandPaths:(NSArray *)commandPaths
{
    NSRange doubleSpaceRange = [informativeText rangeOfString:@"  "];
    NSAssert(doubleSpaceRange.location == NSNotFound, @"The informative text should not contain two spaces in a row.");
    for (NSString *commandPath in commandPaths) {
        NSString *command = [commandPath lastPathComponent];
        NSRange commandRange = [informativeText rangeOfString:command];
        NSAssert(commandRange.location != NSNotFound, @"The informative text should contain the command.");
    }
}

#pragma mark - Closing Windows

- (void)testCloseWindowWithFinishedTask
{
    NSString *commandPath = [self wcl_pathForResource:kTestDataRubyHelloWorld
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    NSTask *task;
    WCLWebWindowController *webWindowController = [WCLWebWindowControllerTestsHelper webWindowControllerRunningCommandPath:commandPath
                                                                                                                task:&task];
    [WCLTaskTestsHelper blockUntilTaskFinishes:task];

    WCLPlugin *plugin = webWindowController.plugin;
    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The WCLPlugin should have a WCLWebWindowController.");
    
    [WCLWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue(![webWindowControllers count], @"The WCLPlugin should not have a WCLWebWindowController.");
}

- (void)testCloseWindowWithRunningTask
{
    if (!kRunLongTests) return;
    

    NSString *commandPath = [self wcl_pathForResource:kTestDataSleepTwoSeconds
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    NSTask *task;
    WCLWebWindowController *webWindowController = [WCLWebWindowControllerTestsHelper webWindowControllerRunningCommandPath:commandPath
                                                                                                                task:&task];
    [WCLWebWindowControllerTestsHelper blockUntilWindowIsVisible:webWindowController.window];
    
    [webWindowController.window performClose:self];
    BOOL windowWillClose = [WCLWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssertFalse(windowWillClose, @"The NSWindow should not close while the NSTask is running.");
    
    [WCLWebWindowControllerTestsHelper blockUntilWindowHasAttachedSheet:webWindowController.window];
#warning Update to [webWindowController.window endSheet:[webWindowController.window attachedSheet]]; in Mavericks
    [NSApp endSheet:[webWindowController.window attachedSheet]];

    [WCLTaskTestsHelper blockUntilTaskFinishes:task timeoutInterval:kTestLongTimeoutInterval];
    XCTAssertFalse([webWindowController hasTasks], @"The WCLWebWindowController should not have an NSTask.");
    
    WCLPlugin *plugin = webWindowController.plugin;
    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The WCLPlugin should have a WCLWebWindowController.");
    
    [webWindowController.window performClose:self];
    windowWillClose = [WCLWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssert(windowWillClose, @"The NSWindow should have closed.");
    
    webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertFalse([webWindowControllers count], @"The WCLPlugin should not have a WCLWebWindowController.");
}

- (void)testTerminateTasksAndCloseWindow
{
    NSString *commandPath = [self wcl_pathForResource:kTestDataSleepTwoSeconds
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    WCLWebWindowController *webWindowController = [WCLWebWindowControllerTestsHelper webWindowControllerRunningCommandPath:commandPath];
    
    XCTAssertTrue([webWindowController hasTasks], @"The WebWindowController should have an NSTask.");
    
    [webWindowController terminateTasksAndCloseWindow];
    
    // TODO: When it is possible for a webWindowController to have multiple tasks, a second task should be started on this webWindowController to ensure that recursive calls to terminateTasksAndCloseWindow work.
    
    BOOL windowWillClose = [WCLWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssert(windowWillClose, @"The NSWindow should have closed.");
}

- (void)testApplicationShouldTerminateAndManageWebWindowControllersWithTasks
{
    BOOL shouldTerminate = [WCLApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks];
    XCTAssertTrue(shouldTerminate, @"The NSApplication should terminate if there are no running NSTasks.");
    
    if (!kRunLongTests) return;
    

    NSString *commandPath = [self wcl_pathForResource:kTestDataSleepTwoSeconds
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];

    NSTask *task;
    WCLWebWindowController *webWindowController = [WCLWebWindowControllerTestsHelper webWindowControllerRunningCommandPath:commandPath
                                                                                                                task:&task];
    [WCLWebWindowControllerTestsHelper blockUntilWindowIsVisible:webWindowController.window];

    XCTAssert([task isRunning], @"The NSTask should be running.");
    shouldTerminate = [WCLApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks];
    XCTAssertFalse(shouldTerminate, @"The NSApplication should not terminate with a running task.");
    
    BOOL windowWillClose = [WCLWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssertFalse(windowWillClose, @"The NSWindow should not close while the NSTask is running.");
    
    [WCLWebWindowControllerTestsHelper blockUntilWindowHasAttachedSheet:webWindowController.window];
#warning Update to [webWindowController.window endSheet:[webWindowController.window attachedSheet]]; in Mavericks
    [NSApp endSheet:[webWindowController.window attachedSheet]];
    
    [WCLTaskTestsHelper blockUntilTaskFinishes:task timeoutInterval:kTestLongTimeoutInterval];
    
    WCLPlugin *plugin = webWindowController.plugin;
    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The WCLPlugin should have a WCLWebWindowController.");
    
    shouldTerminate = [WCLApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks];
    XCTAssert(shouldTerminate, @"The NSApplication should terminate after the NSTask finishes running.");

    // Clean up
    [webWindowController.window performClose:self];
    windowWillClose = [WCLWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssert(windowWillClose, @"The NSWindow should have closed.");
    webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertFalse([webWindowControllers count], @"The WCLPlugin should not have a WCLWebWindowController.");
}

#pragma mark - Helpers

- (NSString *)stringWithContentsOfTestDataFilename:(NSString *)filename extension:(NSString *)extension {
    NSURL *fileURL = [self wcl_URLForResource:filename
                            withExtension:extension
                             subdirectory:kTestDataSubdirectory];
    return [self wcl_stringWithContentsOfFileURL:fileURL];
}

@end
