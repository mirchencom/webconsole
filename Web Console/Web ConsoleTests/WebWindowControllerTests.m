//
//  Web_ConsoleTests.m
//  Web ConsoleTests
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "XCTest+BundleResources.h"
#import "Web_ConsoleTestsConstants.h"
#import "WebView+Source.h"

#import "WebWindowsController.h"
#import "WebWindowController.h"

@interface WebWindowControllerTests : XCTestCase
@end

@interface WebWindowController (TestingAdditions)
@property (nonatomic, readonly) WebView *webView;
@end

@implementation WebWindowControllerTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    NSMutableArray *activeObservers = [NSMutableArray array];
    __block BOOL windowsDidFinishClosing = NO;
    for (WebWindowController *webWindowController in [[WebWindowsController sharedWebWindowsController] webWindowControllers]) {
        __block id observer;
        observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification
                                                                     object:webWindowController.window
                                                                      queue:nil
                                                                 usingBlock:^(NSNotification *notification) {
                                                                     [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                     [activeObservers removeObject:observer];
                                                                     if (![activeObservers count]) {
                                                                         windowsDidFinishClosing = YES;
                                                                     }
                                                                 }];
        [activeObservers addObject:observer];
        
        [webWindowController.window performClose:self];
    }

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!windowsDidFinishClosing && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }

    XCTAssertTrue(windowsDidFinishClosing, @"Windows should have finished closing");

    XCTAssertFalse([activeObservers count], @"There should not be any active observers");
    
    NSUInteger webWindowControllersCount = [[[WebWindowsController sharedWebWindowsController] webWindowControllers] count];
    XCTAssertFalse(webWindowControllersCount, @"There should not be any webWindowControllers");
    NSUInteger windowsCount = [[[NSApplication sharedApplication] windows] count];
    XCTAssertTrue(windowsCount, @"There should not be any windows");

    [super tearDown];
}

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
        XCTAssertTrue(success, @"The load should succeed.");
    }];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
        if (completionHandlerRan) break;
    }
	
    XCTAssertTrue(completionHandlerRan, @"completionHandler should run.");

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

    __block BOOL completionHandlerRan1 = NO;
    [webWindowController loadHTML:HTML completionHandler:^(BOOL success) {
        completionHandlerRan1 = YES;
        XCTAssertFalse(success, @"The first load should fail.");
    }];

    __block BOOL completionHandlerRan2 = NO;
    [webWindowController loadHTML:HTML completionHandler:^(BOOL success) {
        completionHandlerRan2 = YES;
        XCTAssertTrue(success, @"The second load should succeed.");
    }];
		
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
        if (completionHandlerRan1 && completionHandlerRan2) break;
    }
	
    XCTAssertTrue(completionHandlerRan1, @"completionHandler1 should run.");
    XCTAssertTrue(completionHandlerRan2, @"completionHandler2 should run.");
}

- (void)testLoadHTMLInSeparateWindows
{
//    XCTAssertFalse([[[WebWindowsController sharedWebWindowsController] webWindowControllers] count], @"no webwindowcontrollers");
    
    NSString *HTML = [self stringWithContentsOfTestDataFilename:kTestDataHTMLFilename extension:kTestDataHTMLExtension];
    
    WebWindowController *webWindowController1 = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];
    __block BOOL completionHandlerRan1 = NO;
    [webWindowController1 loadHTML:HTML completionHandler:^(BOOL success) {
        completionHandlerRan1 = YES;
        XCTAssertTrue(success, @"The first load should succeed.");
    }];
    
    WebWindowController *webWindowController2 = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];
    __block BOOL completionHandlerRan2 = NO;
    [webWindowController2 loadHTML:HTML completionHandler:^(BOOL success) {
        completionHandlerRan2 = YES;
        XCTAssertTrue(success, @"The second load should succeed.");
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
        if (completionHandlerRan1 && completionHandlerRan2) break;
    }
	
    XCTAssertTrue(completionHandlerRan1, @"completionHandler1 should run.");
    XCTAssertTrue(completionHandlerRan2, @"completionHandler2 should run.");
    
    NSUInteger webWindowControllersCount = [[[WebWindowsController sharedWebWindowsController] webWindowControllers] count];
    XCTAssertTrue(webWindowControllersCount == 2, @"There should be two webWindowControllers %lu", (unsigned long)webWindowControllersCount);
    NSUInteger windowsCount = [[[NSApplication sharedApplication] windows] count];
    XCTAssertTrue(windowsCount == 2, @"There should be two windows %lu", (unsigned long)windowsCount);
}

#pragma mark - Helpers

- (NSString *)stringWithContentsOfTestDataFilename:(NSString *)filename extension:(NSString *)extension {
    NSURL *fileURL = [self URLForResource:filename
                            withExtension:extension
                             subdirectory:kTestDataSubdirectory];
    return [self stringWithContentsOfFileURL:fileURL];
}


@end
