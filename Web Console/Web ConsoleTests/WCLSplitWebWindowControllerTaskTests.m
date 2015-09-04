//
//  WCLSplitWebWindowControllerTaskTests.m
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLSplitWebWindowControllerTestCase.h"

#import "WCLSplitWebWindowControllerTestsHelper.h"

#import "WCLTaskTestsHelper.h"

#import "WCLUserInterfaceTextHelper.h"

#import "WCLApplicationTerminationHelper.h"

#import "WCLSplitWebWindowControllerTestsHelper.h"

#import "Web_Console-Swift.h"

@interface WCLSplitWebWindowControllerTaskTests : WCLSplitWebWindowControllerTestCase
+ (void)testInformativeText:(NSString *)informativeText forCommandPaths:(NSArray *)commandPaths;
@end

@implementation WCLSplitWebWindowControllerTaskTests

#pragma mark - Run Plugin

- (void)testRunPlugin
{
    WCLSplitWebWindowController *splitWebWindowController = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] addedSplitWebWindowController];
    Plugin *plugin = [[PluginsManager sharedInstance] pluginWithName:kTestHelloWorldPluginName];
    [splitWebWindowController runPlugin:plugin withArguments:nil inDirectoryPath:nil completionHandler:nil];
    
    NSArray *splitWebWindowControllers = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin];
    XCTAssertEqual([splitWebWindowControllers count], (NSUInteger)1, @"The WCLPlugin should have one WebWindowController.");
    XCTAssertEqual(splitWebWindowController.plugin, plugin, @"The WCLSplitWebWindowController's WCLPlugin should equal the WCLPlugin.");
    
    // Clean up
    [WCLSplitWebWindowControllerTestsHelper blockUntilWebWindowControllerTasksRunAndFinish:splitWebWindowController];
}


#pragma mark - UserInterfaceTextHelper

- (void)testInformativeTextForCloseWindowForCommands
{
    NSString *informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:@[]];
    XCTAssertNil(informativeText, @"The informative text should be nil for an empty NSArray.");
    
    Plugin *plugin = [[PluginsManager sharedInstance] pluginWithName:kTestPrintPluginName];
    NSArray *commandPaths = @[[plugin commandPath]];
    informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:commandPaths];
    [[self class] testInformativeText:informativeText forCommandPaths:commandPaths];
    
    NSArray *plugins = [[PluginsManager sharedInstance] plugins];
    NSMutableArray *mutableCommandPaths = [[plugins valueForKey:kPluginCommandPathKey] mutableCopy];
    [mutableCommandPaths removeObjectIdenticalTo:[NSNull null]];
    commandPaths = [mutableCommandPaths copy];
    informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:commandPaths];
    [[self class] testInformativeText:informativeText forCommandPaths:commandPaths];
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
    WCLSplitWebWindowController *splitWebWindowController = [self splitWebWindowControllerRunningCommandPath:commandPath
                                                                                                        task:&task];
    [WCLTaskTestsHelper blockUntilTaskFinishes:task];
    
    Plugin *plugin = splitWebWindowController.plugin;
    NSArray *splitWebWindowControllers = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin];
    XCTAssertTrue([splitWebWindowControllers count], @"The WCLPlugin should have a WCLSplitWebWindowController.");
    
    [WCLSplitWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    splitWebWindowControllers = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin];
    XCTAssertTrue(![splitWebWindowControllers count], @"The WCLPlugin should not have a WCLSplitWebWindowController.");
}

- (void)testCloseWindowWithRunningTask
{
    if (!kRunLongTests) return;
    
    
    NSString *commandPath = [self wcl_pathForResource:kTestDataSleepTwoSeconds
                                               ofType:kTestDataRubyExtension
                                         subdirectory:kTestDataSubdirectory];
    NSTask *task;
    WCLSplitWebWindowController *splitWebWindowController = [self splitWebWindowControllerRunningCommandPath:commandPath
                                                                                                                      task:&task];
    [WCLSplitWebWindowControllerTestsHelper blockUntilWindowIsVisible:splitWebWindowController.window];
    
    [splitWebWindowController.window performClose:self];
    BOOL windowWillClose = [WCLSplitWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:splitWebWindowController.window];
    XCTAssertFalse(windowWillClose, @"The NSWindow should not close while the NSTask is running.");
    
    [WCLSplitWebWindowControllerTestsHelper blockUntilWindowHasAttachedSheet:splitWebWindowController.window];

    [splitWebWindowController.window endSheet:[splitWebWindowController.window attachedSheet]];
    
    [WCLTaskTestsHelper blockUntilTaskFinishes:task timeoutInterval:kTestLongTimeoutInterval];
    XCTAssertFalse([splitWebWindowController hasTasks], @"The WCLSplitWebWindowController should not have an NSTask.");
    
    Plugin *plugin = splitWebWindowController.plugin;
    NSArray *splitWebWindowControllers = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin];
    XCTAssertTrue([splitWebWindowControllers count], @"The WCLPlugin should have a WCLSplitWebWindowController.");
    
    [splitWebWindowController.window performClose:self];
    windowWillClose = [WCLSplitWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:splitWebWindowController.window];
    XCTAssert(windowWillClose, @"The NSWindow should have closed.");
    
    splitWebWindowControllers = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin];
    XCTAssertFalse([splitWebWindowControllers count], @"The WCLPlugin should not have a WCLSplitWebWindowController.");
}

- (void)testTerminateTasksAndCloseWindow
{
    NSString *commandPath = [self wcl_pathForResource:kTestDataSleepTwoSeconds
                                               ofType:kTestDataRubyExtension
                                         subdirectory:kTestDataSubdirectory];
    WCLSplitWebWindowController *splitWebWindowController = [self splitWebWindowControllerRunningCommandPath:commandPath];
    
    XCTAssertTrue([splitWebWindowController hasTasks], @"The WebWindowController should have an NSTask.");
    
    [splitWebWindowController terminateTasksAndCloseWindow];
    
    // TODO: When it is possible for a splitWebWindowController to have multiple tasks, a second task should be started on this splitWebWindowController to ensure that recursive calls to terminateTasksAndCloseWindow work.
    
    BOOL windowWillClose = [WCLSplitWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:splitWebWindowController.window];
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
    WCLSplitWebWindowController *splitWebWindowController = [self splitWebWindowControllerRunningCommandPath:commandPath
                                                                                                        task:&task];
    [WCLSplitWebWindowControllerTestsHelper blockUntilWindowIsVisible:splitWebWindowController.window];
    
    XCTAssert([task isRunning], @"The NSTask should be running.");
    shouldTerminate = [WCLApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks];
    XCTAssertFalse(shouldTerminate, @"The NSApplication should not terminate with a running task.");
    
    BOOL windowWillClose = [WCLSplitWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:splitWebWindowController.window];
    XCTAssertFalse(windowWillClose, @"The NSWindow should not close while the NSTask is running.");
    
    [WCLSplitWebWindowControllerTestsHelper blockUntilWindowHasAttachedSheet:splitWebWindowController.window];

    [splitWebWindowController.window endSheet:[splitWebWindowController.window attachedSheet]];
    
    [WCLTaskTestsHelper blockUntilTaskFinishes:task timeoutInterval:kTestLongTimeoutInterval];
    
    Plugin *plugin = splitWebWindowController.plugin;
    NSArray *splitWebWindowControllers = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin];
    XCTAssertTrue([splitWebWindowControllers count], @"The WCLPlugin should have a WCLSplitWebWindowController.");
    
    shouldTerminate = [WCLApplicationTerminationHelper applicationShouldTerminateAndManageWebWindowControllersWithTasks];
    XCTAssert(shouldTerminate, @"The NSApplication should terminate after the NSTask finishes running.");
    
    // Clean up
    [splitWebWindowController.window performClose:self];
    windowWillClose = [WCLSplitWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:splitWebWindowController.window];
    XCTAssert(windowWillClose, @"The NSWindow should have closed.");
    splitWebWindowControllers = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin];
    XCTAssertFalse([splitWebWindowControllers count], @"The WCLPlugin should not have a WCLSplitWebWindowController.");
}

- (void)testDocumentEditingWhileRunningTask
{
    if (!kRunLongTests) return;

    NSString *commandPath = [self wcl_pathForResource:kTestDataSleepTwoSeconds
                                               ofType:kTestDataRubyExtension
                                         subdirectory:kTestDataSubdirectory];
    NSTask *task;
    WCLSplitWebWindowController *splitWebWindowController = [self splitWebWindowControllerRunningCommandPath:commandPath
                                                                                                        task:&task];
    XCTAssertTrue([splitWebWindowController.window isDocumentEdited], @"The NSWindow should be edited while running a task");
    [WCLSplitWebWindowControllerTestsHelper blockUntilWindowIsVisible:splitWebWindowController.window];
    
    [WCLTaskTestsHelper blockUntilTaskFinishes:task timeoutInterval:kTestLongTimeoutInterval];
    XCTAssertFalse([splitWebWindowController.window isDocumentEdited], @"The NSWindow should not be edited after running a task");
    
    // Clean Up
    [splitWebWindowController.window performClose:self];
    BOOL windowWillClose = [WCLSplitWebWindowControllerTestsHelper windowWillCloseBeforeTimeout:splitWebWindowController.window];
    XCTAssert(windowWillClose, @"The NSWindow should have closed.");
}

- (void)testPluginTaskEnvironmentDictionary
{
    WCLSplitWebWindowController *splitWebWindowController = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] addedSplitWebWindowController];
    Plugin *plugin = [[PluginsManager sharedInstance] pluginWithName:kTestTestEnvironmentPluginName];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Running task"];
    [splitWebWindowController runPlugin:plugin withArguments:nil inDirectoryPath:nil completionHandler:^(BOOL success) {
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:kTestTimeoutInterval handler:nil];
    
    NSAssert([splitWebWindowController hasTasks], @"The WCLSplitWebWindowController should have an NSTask.");
    NSTask *task = splitWebWindowController.tasks[0];
    [WCLTaskTestsHelper blockUntilTasksRunAndFinish:@[task]];

    NSTaskTerminationReason terminationReason = [task terminationReason];
    int terminationStatus = [task terminationStatus];
    
    NSAssert(terminationReason == NSTaskTerminationReasonExit, @"The NSTask's termination reason should be exit.");
    NSAssert(terminationStatus == 0, @"The NSTask's termination status should be 0.");
}

@end
