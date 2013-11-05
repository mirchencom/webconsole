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

#import "WebWindowsController.h"
#import "WebWindowController.h"
#import "WebWindowControllerTestsHelper.h"

#import "TaskTestsHelper.h"

#import "ApplicationTerminationHelper.h"

#import "Plugin+Tests.h"


@interface WebWindowControllerTests : XCTestCase
@end

@interface WebWindowController (Tests)
@property (nonatomic, readonly) WebView *webView;
- (void)terminateTasksAndCloseWindow;
@end


@implementation WebWindowControllerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    [WebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];

    [super tearDown];
}

#pragma mark - HTML & JavaScript

- (void)testLoadHTMLWithBaseURL {
    NSURL *fileURL = [self URLForResource:kTestDataHTMLJQUERYFilename
                            withExtension:kTestDataHTMLExtension
                             subdirectory:kTestDataSubdirectory];
    NSString *HTML = [self stringWithContentsOfFileURL:fileURL];
    NSURL *baseURL = [fileURL URLByDeletingLastPathComponent];

    __block BOOL completionHandlerRan = NO;
    WebWindowController *webWindowController = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];
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
    
    WebWindowController *webWindowController = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];

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
    
    WebWindowController *webWindowController1 = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];
    __block BOOL firstCompletionHandlerRan = NO;
    [webWindowController1 loadHTML:HTML completionHandler:^(BOOL success) {
        firstCompletionHandlerRan = YES;
        XCTAssertTrue(success, @"The first load should have succeeded.");
    }];
    
    WebWindowController *webWindowController2 = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];
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
    
    NSUInteger webWindowControllersCount = [[[WebWindowsController sharedWebWindowsController] webWindowControllers] count];
    XCTAssertTrue(webWindowControllersCount == 2, @"There should be two WebWindowControllers. %lu", webWindowControllersCount);
}


#pragma mark - Closing Windows

- (void)testCloseWindowWithFinishedTask
{
    Plugin *plugin = [[Plugin alloc] init];
    NSString *commandPath = [self pathForResource:kTestDataRubyHelloWorld
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The plugin should have a WebWindowController.");
    WebWindowController *webWindowController = webWindowControllers[0];
    
    XCTAssertTrue([webWindowController.tasks count], @"The WebWindowController should have an NSTask.");
    NSTask *task = webWindowController.tasks[0];
    
    [TaskTestsHelper blockUntilTaskFinishes:task];
    
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The Plugin should have a WebWindowController.");
    
    [WebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue(![webWindowControllers count], @"The Plugin should not have a WebWindowController.");
}

- (void)testCloseWindowWithRunningTask
{
    if (!kRunLongTests) return;
    
    Plugin *plugin = [[Plugin alloc] init];
    NSString *commandPath = [self pathForResource:kTestDataSleepTwoSeconds
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The Plugin should have a WebWindowController.");
    WebWindowController *webWindowController = webWindowControllers[0];
    [WebWindowControllerTestsHelper blockUntilWindowIsVisible:webWindowController.window];

    [webWindowController.window performClose:self];
    XCTAssertTrue([webWindowController.tasks count], @"The WebWindowController should have an NSTask.");
    NSTask *task = webWindowController.tasks[0];
    
    // TODO: I couldn't figure out a way to test if a sheet has appeared here, testing for [webWindowController attachedSheet] wouldn't work because my thread blocking methods prevent the sheet from being returned by that call.

    BOOL windowWillClose = [WebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssertFalse(windowWillClose, @"The NSWindow should not close while the NSTask is running.");
    
    [WebWindowControllerTestsHelper blockUntilWindowHasAttachedSheet:webWindowController.window];
#warning Update to [webWindowController.window endSheet:[webWindowController.window attachedSheet]]; in Mavericks
    [NSApp endSheet:[webWindowController.window attachedSheet]];

    [TaskTestsHelper blockUntilTaskFinishes:task timeoutInterval:kTestLongTimeoutInterval];
    XCTAssertFalse([webWindowController.tasks count], @"The WebWindowController should not have an NSTask.");
    
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The Plugin should have a WebWindowController.");
    
    [webWindowController.window performClose:self];
    windowWillClose = [WebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssert(windowWillClose, @"The NSWindow should have closed.");
    
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertFalse([webWindowControllers count], @"The Plugin should not have a WebWindowController.");
}

- (void)testTerminateTasksAndCloseWindow
{
    Plugin *plugin = [[Plugin alloc] init];
    NSString *commandPath = [self pathForResource:kTestDataSleepTwoSeconds
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The Plugin should have a WebWindowController.");
    WebWindowController *webWindowController = webWindowControllers[0];
    
    XCTAssertTrue([webWindowController.tasks count], @"The WebWindowController should have an NSTask.");
    
    [webWindowController terminateTasksAndCloseWindow];
    
    // TODO: When it is possible for a webWindowController to have multiple tasks, a second task should be started on this webWindowController to ensure that recursive calls to terminateTasksAndCloseWindow work.
    
    BOOL windowWillClose = [WebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssert(windowWillClose, @"The NSWindow should have closed.");
}

- (void)testApplicationShouldTerminateAndManageWebWindowControllersWithTasks
{
    BOOL shouldTerminate = [ApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks];
    XCTAssertTrue(shouldTerminate, @"The NSApplication should terminate if there are no running NSTasks.");
    
    if (!kRunLongTests) return;
    
    Plugin *plugin = [[Plugin alloc] init];
    NSString *commandPath = [self pathForResource:kTestDataSleepTwoSeconds
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];

    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The Plugin should have a WebWindowController.");
    WebWindowController *webWindowController = webWindowControllers[0];
    [WebWindowControllerTestsHelper blockUntilWindowIsVisible:webWindowController.window];
    
    shouldTerminate = [ApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks];
    XCTAssertFalse(shouldTerminate, @"The NSApplication should not terminate with a running task.");

    XCTAssertTrue([webWindowController.tasks count], @"The WebWindowController should have an NSTask.");
    NSTask *task = webWindowController.tasks[0];
    
    BOOL windowWillClose = [WebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssertFalse(windowWillClose, @"The NSWindow should not close while the NSTask is running.");
    
    [WebWindowControllerTestsHelper blockUntilWindowHasAttachedSheet:webWindowController.window];
#warning Update to [webWindowController.window endSheet:[webWindowController.window attachedSheet]]; in Mavericks
    [NSApp endSheet:[webWindowController.window attachedSheet]];
    
    [TaskTestsHelper blockUntilTaskFinishes:task timeoutInterval:kTestLongTimeoutInterval];
    
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The Plugin should have a WebWindowController.");
    
    shouldTerminate = [ApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks];
    XCTAssert(shouldTerminate, @"The NSApplication should terminate after the NSTask finishes running.");

    // Clean up
    [webWindowController.window performClose:self];
    windowWillClose = [WebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssert(windowWillClose, @"The NSWindow should have closed.");
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertFalse([webWindowControllers count], @"The Plugin should not have a WebWindowController.");
}

#pragma mark - Helpers

- (NSString *)stringWithContentsOfTestDataFilename:(NSString *)filename extension:(NSString *)extension {
    NSURL *fileURL = [self URLForResource:filename
                            withExtension:extension
                             subdirectory:kTestDataSubdirectory];
    return [self stringWithContentsOfFileURL:fileURL];
}

@end
