//
//  PluginTests.m
//  Web Console
//
//  Created by Roben Kleene on 10/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Web_ConsoleTestsConstants.h"
#import "XCTest+BundleResources.h"
#import "WebWindowControllerTestsHelper.h"
#import "PluginTestsHelper.h"

#import "WebWindowsController.h"
#import "WebWindowController.h"

#import "NSTask+Termination.h"

#import "Plugin.h"

@interface Plugin (PluginTests)
- (void)runCommandPath:(NSString *)commandPath
         withArguments:(NSArray *)arguments
      withResourcePath:(NSString *)resourcePath
       inDirectoryPath:(NSString *)directoryPath;
@end

@interface WebWindowController (PluginTests)
- (void)terminateTasksAndCloseWindow;
@end



@interface PluginTests : XCTestCase

@end

@implementation PluginTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    [WebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    [super tearDown];
}

#pragma mark - Interrupt & Termination

- (void)testInterrupt
{
    // TODO: Right now there it isn't possible for a WebWindowController to run multiple tasks, when this is possible, this test should be updated to use mutliple tasks.
    
    Plugin *plugin = [[Plugin alloc] init];
    NSString *commandPath = [self pathForResource:kTestDataSleepTwoSeconds
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The Plugin should have a WebWindowController.");
    WebWindowController *webWindowController = webWindowControllers[0];
    
    XCTAssertTrue([webWindowController.tasks count], @"The WebWindowController should have an NSTask.");
    NSTask *task = webWindowController.tasks[0];

    __block BOOL completionHandlerRan = NO;
    [task interruptWithCompletionHandler:^(BOOL success) {
        XCTAssertTrue(success, @"The interrupted should have succeeded.");
        completionHandlerRan = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!completionHandlerRan && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    XCTAssertTrue(completionHandlerRan, @"The completion handler should have run.");

    XCTAssertFalse([task isRunning], @"The NSTask should not be running.");
    XCTAssertFalse([webWindowController.tasks count], @"The WebWindowController should not have any NSTasks.");
}

- (void)testInterruptAndTerminate
{
    Plugin *plugin = [[Plugin alloc] init];
    NSString *commandPath = [self pathForResource:kTestDataInterruptFails
                                           ofType:kTestDataShellScriptExtension
                                     subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The Plugin should have a WebWindowController.");
    WebWindowController *webWindowController = webWindowControllers[0];
    
    XCTAssertTrue([webWindowController.tasks count], @"The WebWindowController should have an NSTask.");
    NSTask *task = webWindowController.tasks[0];
    
    __block BOOL completionHandlerRan = NO;
    [task interruptWithCompletionHandler:^(BOOL success) {
        // TODO: For some reason terminating the task is actually succeeding here even though it should fail. If I can get this to fail, write the rest of the test to do a terminate after failing an interrupt.
//        XCTAssertFalse(success, @"The interrupted should have failed.");
        completionHandlerRan = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!completionHandlerRan && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    XCTAssertTrue(completionHandlerRan, @"The completion handler should have run.");

    // TODO: If I can figure out a way to run a script that doesn't interrupt, then put the terminate here
    
    XCTAssertFalse([task isRunning], @"The NSTask should not be running.");
    XCTAssertFalse([webWindowController.tasks count], @"The WebWindowController should not have any NSTasks.");
}

#pragma mark - Ordered Windows

- (void)testOrderedWindows
{
    Plugin *plugin = [[Plugin alloc] init];
    NSString *commandPath = [self pathForResource:kTestDataRubyHelloWorld
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertEqual([webWindowControllers count], (NSUInteger)1, @"The plugin should have one WebWindowController.");
    WebWindowController *firstWebWindowController = webWindowControllers[0];

    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertEqual([webWindowControllers count], (NSUInteger)2, @"The plugin should have two WebWindowControllers.");
    WebWindowController *secondWebWindowController = webWindowControllers[1];

    XCTAssertEqualObjects(firstWebWindowController, webWindowControllers[0], @"The first WebWindowController should still be at the first index.");
    XCTAssertNotEqualObjects(firstWebWindowController, secondWebWindowController, @"The WebWindowControllers should not be equal.");

    NSArray *pluginOrderedWindows = [plugin orderedWindows];
    XCTAssertTrue([pluginOrderedWindows containsObject:firstWebWindowController.window], @"The plugin ordered NSWindows should contain the first WebWindowControllers NSWindow.");
    XCTAssertTrue([pluginOrderedWindows containsObject:secondWebWindowController.window], @"The plugin ordered NSWindows should contain the second WebWindowControllers NSWindow.");
    NSUInteger pluginIndexOfFirst = [pluginOrderedWindows indexOfObject:firstWebWindowController.window];
    NSUInteger pluginIndexOfsecond = [pluginOrderedWindows indexOfObject:secondWebWindowController.window];

    NSArray *applicationOrderedWindows = [[NSApplication sharedApplication] orderedWindows];
    XCTAssertTrue([applicationOrderedWindows containsObject:firstWebWindowController.window], @"The application ordered NSWindows should contain the first WebWindowControllers NSWindow.");
    XCTAssertTrue([applicationOrderedWindows containsObject:secondWebWindowController.window], @"The application ordered NSWindows should contain the second WebWindowControllers NSWindow.");
    NSUInteger applicationIndexOfFirst = [applicationOrderedWindows indexOfObject:firstWebWindowController.window];
    NSUInteger applicationIndexOfsecond = [applicationOrderedWindows indexOfObject:secondWebWindowController.window];
    
    BOOL orderMatches = (pluginIndexOfFirst > pluginIndexOfsecond) == (applicationIndexOfFirst > applicationIndexOfsecond);
    XCTAssert(orderMatches, @"The order of the NSWindows returned by the Plugin should match the order returned by the NSApplication.");
    
    // Clean up
    NSArray *tasks = [[WebWindowsController sharedWebWindowsController] tasks];
    XCTAssertEqual([tasks count], (NSUInteger)2, @"There should be two NSTasks.");
    [PluginTestsHelper blockUntilTasksFinish:tasks];
}

#pragma mark - Window Management

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

    [PluginTestsHelper blockUntilTaskFinishes:task];

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
    
    [webWindowController.window performClose:self];

    XCTAssertTrue([webWindowController.tasks count], @"The WebWindowController should have an NSTask.");
    NSTask *task = webWindowController.tasks[0];
    
    BOOL windowWillClose = [WebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssertFalse(windowWillClose, @"The NSWindow should not close while the NSTask is running.");
    
    [PluginTestsHelper blockUntilTaskFinishes:task timeoutInterval:kTestLongTimeoutInterval];
 
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The Plugin should have a WebWindowController.");
    
    [WebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
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

@end
