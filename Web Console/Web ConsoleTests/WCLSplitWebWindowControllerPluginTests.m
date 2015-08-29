//
//  WCLPluginWebWindowControllerTests.m
//  Web Console
//
//  Created by Roben Kleene on 2/8/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "Web_ConsoleTestsConstants.h"
#import "XCTest+BundleResources.h"

#import "WCLSplitWebWindowsController.h"
#import "WCLSplitWebWindowController.h"
#import "WCLSplitWebWindowControllerTestsHelper.h"
#import "WCLSplitWebWindowControllerTestCase.h"

#import "NSTask+Termination.h"
#import "WCLTaskTestsHelper.h"
#import "WCLTaskHelper.h"
#import "Web_Console-Swift.h"


@interface WCLSplitWebWindowControllerPluginTests : WCLSplitWebWindowControllerTestCase

@end

@implementation WCLSplitWebWindowControllerPluginTests

#pragma mark - AppleScript

- (void)testReadFromStandardInput
{
    NSString *commandPath = [self wcl_pathForResource:kTestDataCat
                                               ofType:kTestDataShellScriptExtension
                                         subdirectory:kTestDataSubdirectory];
    NSTask *task;
    WCLSplitWebWindowController *splitWebWindowController = [[self class] splitWebWindowControllerRunningCommandPath:commandPath
                                                                                                 task:&task];
    static NSString *StandardInputText = @"Test String";
    
    __block BOOL completionHandlerRan = NO;
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSString *standardOutputText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        XCTAssert([standardOutputText isEqualToString:StandardInputText], @"The standard input text should match the standard output text.");
        completionHandlerRan = YES;
    }];
    [splitWebWindowController readFromStandardInput:StandardInputText];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!completionHandlerRan && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    NSAssert(completionHandlerRan, @"The completion handler should have run.");
    
    // Clean up
    [WCLTaskTestsHelper interruptTaskAndblockUntilTaskFinishes:task];
    XCTAssertFalse([splitWebWindowController hasTasks], @"The WCLSplitWebWindowController should not have any NSTasks.");
}

#pragma mark - Interrupt & Termination

- (void)testInterrupt
{
    // TODO: Right now there it isn't possible for a WCLSplitWebWindowController to run multiple tasks, when this is possible, this test should be updated to use multiple tasks.
    
    NSString *commandPath = [self wcl_pathForResource:kTestDataSleepTwoSeconds
                                               ofType:kTestDataRubyExtension
                                         subdirectory:kTestDataSubdirectory];
    NSTask *task;
    WCLSplitWebWindowController *splitWebWindowController = [[self class] splitWebWindowControllerRunningCommandPath:commandPath
                                                                                                 task:&task];
    __block BOOL completionHandlerRan = NO;
    [task wcl_interruptWithCompletionHandler:^(BOOL success) {
        XCTAssertTrue(success, @"The interrupted should have succeeded.");
        completionHandlerRan = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!completionHandlerRan && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    XCTAssertTrue(completionHandlerRan, @"The completion handler should have run.");
    
    XCTAssertFalse([task isRunning], @"The NSTask should not be running.");
    XCTAssertFalse([splitWebWindowController hasTasks], @"The WCLSplitWebWindowController should not have any NSTasks.");
}

- (void)testInterruptAndTerminate
{
    
    NSString *commandPath = [self wcl_pathForResource:kTestDataInterruptFails
                                               ofType:kTestDataShellScriptExtension
                                         subdirectory:kTestDataSubdirectory];
    NSTask *task;
    WCLSplitWebWindowController *splitWebWindowController = [[self class] splitWebWindowControllerRunningCommandPath:commandPath
                                                                                                 task:&task];
    
    __block BOOL completionHandlerRan = NO;
    [task wcl_interruptWithCompletionHandler:^(BOOL success) {
        // TODO: For some reason terminating the task is actually succeeding here even though it should fail. If I can get this to fail, write the rest of the test to do a terminate after failing an interrupt.
        //        XCTAssertFalse(success, @"The interrupted should have failed.");
        completionHandlerRan = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!completionHandlerRan && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    XCTAssertTrue(completionHandlerRan, @"The completion handler should have run.");
    
    // TODO: If there's a a way to run a script that doesn't interrupt, then put the terminate here
    
    XCTAssertFalse([task isRunning], @"The NSTask should not be running.");
    XCTAssertFalse([splitWebWindowController hasTasks], @"The WCLSplitWebWindowController should not have any NSTasks.");
}

- (void)testTerminateTasks
{
    NSString *firstCommandPath = [self wcl_pathForResource:kTestDataSleepTwoSeconds
                                                    ofType:kTestDataRubyExtension
                                              subdirectory:kTestDataSubdirectory];
    NSTask *firstTask = [[self class] taskRunningCommandPath:firstCommandPath];
    
    NSString *secondCommandPath = [self wcl_pathForResource:kTestDataInterruptFails
                                                     ofType:kTestDataShellScriptExtension
                                               subdirectory:kTestDataSubdirectory];
    NSTask *secondTask = [[self class] taskRunningCommandPath:secondCommandPath];
    
    XCTAssertTrue([firstTask isRunning], @"The first NSTask should be running.");
    XCTAssertTrue([secondTask isRunning], @"The second NSTask should be running.");
    
    __block BOOL completionHandlerRan = NO;
    [WCLTaskHelper terminateTasks:@[firstTask, secondTask] completionHandler:^(BOOL success) {
        XCTAssert(success, @"Terminating the NSTasks should have suceeded.");
        completionHandlerRan = YES;
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!completionHandlerRan && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    XCTAssertTrue(completionHandlerRan, @"The completion handler should have run.");
    
    XCTAssertFalse([firstTask isRunning], @"The first NSTask should not be running.");
    XCTAssertFalse([secondTask isRunning], @"The second NSTask should not be running.");
}

#pragma mark - Ordered Windows

- (void)testOrderedWindows
{
    NSString *commandPath = [self wcl_pathForResource:kTestDataRubyHelloWorld
                                               ofType:kTestDataRubyExtension
                                         subdirectory:kTestDataSubdirectory];
    Plugin *plugin = [[PluginsManager sharedInstance] pluginWithName:kTestPrintPluginName];
    [plugin runCommandPath:commandPath withArguments:nil inDirectoryPath:nil];
    NSArray *splitWebWindowControllers = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin];
    XCTAssertEqual([splitWebWindowControllers count], (NSUInteger)1, @"The WCLPlugin should have one WCLSplitWebWindowController.");
    WCLSplitWebWindowController *firstWebWindowController = splitWebWindowControllers[0];
    
    [plugin runCommandPath:commandPath withArguments:nil inDirectoryPath:nil];
    splitWebWindowControllers = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin];
    XCTAssertEqual([splitWebWindowControllers count], (NSUInteger)2, @"The WCLPlugin should have two WCLSplitWebWindowControllers.");
    WCLSplitWebWindowController *secondWebWindowController = splitWebWindowControllers[1];
    
    XCTAssertEqualObjects(firstWebWindowController, splitWebWindowControllers[0], @"The first WCLSplitWebWindowController should still be at the first index.");
    XCTAssertNotEqualObjects(firstWebWindowController, secondWebWindowController, @"The WCLSplitWebWindowControllers should not be equal.");
    
    NSArray *pluginOrderedWindows = [plugin orderedWindows];
    XCTAssertTrue([pluginOrderedWindows containsObject:firstWebWindowController.window], @"The plugin ordered NSWindows should contain the first WCLSplitWebWindowControllers NSWindow.");
    XCTAssertTrue([pluginOrderedWindows containsObject:secondWebWindowController.window], @"The plugin ordered NSWindows should contain the second WCLSplitWebWindowControllers NSWindow.");
    NSUInteger pluginIndexOfFirst = [pluginOrderedWindows indexOfObject:firstWebWindowController.window];
    NSUInteger pluginIndexOfsecond = [pluginOrderedWindows indexOfObject:secondWebWindowController.window];
    
    NSArray *applicationOrderedWindows = [[NSApplication sharedApplication] orderedWindows];
    XCTAssertTrue([applicationOrderedWindows containsObject:firstWebWindowController.window], @"The application ordered NSWindows should contain the first WCLSplitWebWindowControllers NSWindow.");
    XCTAssertTrue([applicationOrderedWindows containsObject:secondWebWindowController.window], @"The application ordered NSWindows should contain the second WCLSplitWebWindowControllers NSWindow.");
    NSUInteger applicationIndexOfFirst = [applicationOrderedWindows indexOfObject:firstWebWindowController.window];
    NSUInteger applicationIndexOfsecond = [applicationOrderedWindows indexOfObject:secondWebWindowController.window];
    
    BOOL orderMatches = (pluginIndexOfFirst > pluginIndexOfsecond) == (applicationIndexOfFirst > applicationIndexOfsecond);
    XCTAssert(orderMatches, @"The order of the NSWindows returned by the WCLPlugin should match the order returned by the NSApplication.");
    
    // Clean up
    NSArray *tasks = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] tasks];
    XCTAssertEqual([tasks count], (NSUInteger)2, @"There should be two NSTasks.");
    
    [WCLTaskTestsHelper blockUntilTasksRunAndFinish:tasks];
}

@end
