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
    [super tearDown];

    [WebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
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
    XCTAssertTrue([webWindowControllers count], @"The plugin should have a webWindowController");
    WebWindowController *webWindowController = webWindowControllers[0];
    
    XCTAssertTrue([webWindowController.tasks count], @"The webWindowController should have a task");
    NSTask *task = webWindowController.tasks[0];

    __block BOOL completionHandlerRan = NO;
    [task interruptWithCompletionHandler:^(BOOL success) {
        XCTAssertTrue(success, @"The interrupted should have succeeded");
        completionHandlerRan = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!completionHandlerRan && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    XCTAssertTrue(completionHandlerRan, @"The completion handler should have run");

    XCTAssertFalse([task isRunning], @"The task should not be running");
    XCTAssertFalse([webWindowController.tasks count], @"The webWindowController should not have any tasks");
}

- (void)testInterruptAndTerminate
{
    Plugin *plugin = [[Plugin alloc] init];
    NSString *commandPath = [self pathForResource:kTestDataInterruptFails
                                           ofType:kTestDataShellScriptExtension
                                     subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The plugin should have a webWindowController");
    WebWindowController *webWindowController = webWindowControllers[0];
    
    XCTAssertTrue([webWindowController.tasks count], @"The webWindowController should have a task");
    NSTask *task = webWindowController.tasks[0];
    
    __block BOOL completionHandlerRan = NO;
    [task interruptWithCompletionHandler:^(BOOL success) {
        // TODO: For some reason terminating the task is actually succeeding here even though it should fail. If I can get this to fail, write the rest of the test to do a terminate after failing an interrupt.
//        XCTAssertFalse(success, @"The interrupted should have failed");
        completionHandlerRan = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!completionHandlerRan && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    XCTAssertTrue(completionHandlerRan, @"The completion handler should have run");

    // TODO: Put the terminate here, if I can figure out a way to run a script that doesn't interrupt
    
    XCTAssertFalse([task isRunning], @"The task should not be running");
    XCTAssertFalse([webWindowController.tasks count], @"The webWindowController should not have any tasks");
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
    XCTAssertTrue([webWindowControllers count], @"The plugin should have a webWindowController");
    WebWindowController *webWindowController = webWindowControllers[0];

    XCTAssertTrue([webWindowController.tasks count], @"The webWindowController should have a task");
    NSTask *task = webWindowController.tasks[0];

    [PluginTestsHelper blockUntilTaskFinishes:task];

    [WebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue(![webWindowControllers count], @"The plugin should not have a webWindowController");
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
    XCTAssertTrue([webWindowControllers count], @"The plugin should have a webWindowController");
    WebWindowController *webWindowController = webWindowControllers[0];
    
    [webWindowController.window performClose:self];

    XCTAssertTrue([webWindowController.tasks count], @"The webWindowController should have a task");
    NSTask *task = webWindowController.tasks[0];
    
    BOOL windowWillClose = [WebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];
    XCTAssertFalse(windowWillClose, @"The window should not close while the task is running");
    
    [PluginTestsHelper blockUntilTaskFinishes:task timeoutInterval:kTestLongTimeoutInterval];
    
    [WebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue(![webWindowControllers count], @"The plugin should not have a webWindowController");
}

- (void)testTerminateTasksAndCloseWindow
{
    Plugin *plugin = [[Plugin alloc] init];
    NSString *commandPath = [self pathForResource:kTestDataSleepTwoSeconds
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue([webWindowControllers count], @"The plugin should have a webWindowController");
    WebWindowController *webWindowController = webWindowControllers[0];
    
    XCTAssertTrue([webWindowController.tasks count], @"The webWindowController should have a task");

    [webWindowController terminateTasksAndCloseWindow];

    // TODO: When it is possible for a webWindowController to have multiple tasks, a second task should be started on this webWindowController to ensure that recursive calls to terminateTasksAndCloseWindow work.
    
    BOOL windowWillClose = [WebWindowControllerTestsHelper windowWillCloseBeforeTimeout:webWindowController.window];

    XCTAssert(windowWillClose, @"Window should close");
}

@end
