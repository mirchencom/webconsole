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

#import "WCLWebWindowsController.h"
#import "WCLWebWindowController.h"
#import "WCLWebWindowControllerTestsHelper.h"

#import "NSTask+Termination.h"
#import "WCLTaskTestsHelper.h"
#import "WCLTaskHelper.h"

#import "WCLPlugin.h"
#import "WCLPluginManager.h"
#import "WCLPlugin+Tests.h"

@interface WCLPluginTests : XCTestCase
@end

@implementation WCLPluginTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    [WCLWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    [super tearDown];
}


#pragma mark - Plugin Bundle

- (void)testPlugin
{
    NSURL *pluginURL = [[self class] wcl_URLForSharedTestResource:kTestPrintPluginName
                                                    withExtension:kPlugInExtension
                                                     subdirectory:kSharedTestResourcesPluginSubdirectory];
    WCLPlugin *plugin = [[WCLPluginManager sharedPluginManager] addedPluginAtURL:pluginURL];
    XCTAssertNotNil(plugin, @"The WCLPlugin should not be nil.");
    
    // Test Resource Path & URL
    BOOL isDir;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[plugin resourcePath] isDirectory:&isDir];
    XCTAssertTrue(fileExists, @"A file should exist at the WCLPlugin's resource path.");
    XCTAssertTrue(isDir, @"The WCLPlugin's resource path should be a directory.");
    XCTAssertTrue([[plugin resourcePath] isEqualToString:[[plugin resourceURL] path]], @"The WCLPlugin's resource path should equal the path to its resource URL.");
    
    // Test Command
    XCTAssertEqualObjects([plugin command], kTestPrintPluginCommand, @"The WCLPlugin's command should match the test plugin command.");
    XCTAssertTrue([[plugin commandPath] hasPrefix:[plugin resourcePath]], @"The WCLPlugin's command path should begin with it's resource path.");
    XCTAssertTrue([[plugin commandPath] hasSuffix:[plugin command]], @"The WCLPlugin's command path should end with it's command.");

    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[plugin commandPath] isDirectory:&isDir];
    XCTAssertTrue(fileExists, @"A file should exist at the WCLPlugin's command path.");
    XCTAssertFalse(isDir, @"The WCLPlugin's command path should not be a directory.");
}

- (void)testSharedResources
{
    NSString *testSharedResourcePath = [[[WCLPluginManager sharedPluginManager] sharedResourcesPath] stringByAppendingPathComponent:kTestSharedResourcePathComponent];
    BOOL isDir;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:testSharedResourcePath isDirectory:&isDir];
    XCTAssertTrue(fileExists, @"A file should exist at the test shared resource's path.");
    XCTAssertFalse(isDir, @"The test shared resource should not be a directory.");

    NSURL *testSharedResourceURL = [[[WCLPluginManager sharedPluginManager] sharedResourcesURL] URLByAppendingPathComponent:kTestSharedResourcePathComponent];
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[testSharedResourceURL path] isDirectory:&isDir];
    XCTAssertTrue(fileExists, @"A file should exist at the test shared resource's URL.");
    XCTAssertFalse(isDir, @"The test shared resource should not be a directory.");
}

#pragma mark - AppleScript

- (void)testReadFromStandardInput
{
    NSString *commandPath = [self wcl_pathForResource:kTestDataCat
                                               ofType:kTestDataShellScriptExtension
                                         subdirectory:kTestDataSubdirectory];
    NSTask *task;
    WCLWebWindowController *webWindowController = [WCLWebWindowControllerTestsHelper webWindowControllerRunningCommandPath:commandPath
                                                                                                                      task:&task];
    WCLPlugin *plugin = webWindowController.plugin;

    static NSString *StandardInputText = @"Test String";

    __block BOOL completionHandlerRan = NO;
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSString *standardOutputText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        XCTAssert([standardOutputText isEqualToString:StandardInputText], @"The standard input text should match the standard output text.");
        completionHandlerRan = YES;
    }];
    [plugin readFromStandardInput:StandardInputText];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!completionHandlerRan && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    NSAssert(completionHandlerRan, @"The completion handler should have run.");
    
    // Clean up
    [WCLTaskTestsHelper interruptTaskAndblockUntilTaskFinishes:task];
    XCTAssertFalse([webWindowController hasTasks], @"The WCLWebWindowController should not have any NSTasks.");
}


#pragma mark - Interrupt & Termination

- (void)testInterrupt
{
    // TODO: Right now there it isn't possible for a WCLWebWindowController to run multiple tasks, when this is possible, this test should be updated to use mutliple tasks.
    
    NSString *commandPath = [self wcl_pathForResource:kTestDataSleepTwoSeconds
                                           ofType:kTestDataRubyExtension
                                     subdirectory:kTestDataSubdirectory];
    NSTask *task;
    WCLWebWindowController *webWindowController = [WCLWebWindowControllerTestsHelper webWindowControllerRunningCommandPath:commandPath
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
    XCTAssertFalse([webWindowController hasTasks], @"The WCLWebWindowController should not have any NSTasks.");
}

- (void)testInterruptAndTerminate
{

    NSString *commandPath = [self wcl_pathForResource:kTestDataInterruptFails
                                           ofType:kTestDataShellScriptExtension
                                     subdirectory:kTestDataSubdirectory];
    NSTask *task;
    WCLWebWindowController *webWindowController = [WCLWebWindowControllerTestsHelper webWindowControllerRunningCommandPath:commandPath
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

    // TODO: If I can figure out a way to run a script that doesn't interrupt, then put the terminate here
    
    XCTAssertFalse([task isRunning], @"The NSTask should not be running.");
    XCTAssertFalse([webWindowController hasTasks], @"The WCLWebWindowController should not have any NSTasks.");
}

- (void)testTerminateTasks
{
    NSString *firstCommandPath = [self wcl_pathForResource:kTestDataSleepTwoSeconds
                                                ofType:kTestDataRubyExtension
                                          subdirectory:kTestDataSubdirectory];
    NSTask *firstTask = [WCLWebWindowControllerTestsHelper taskRunningCommandPath:firstCommandPath];

    NSString *secondCommandPath = [self wcl_pathForResource:kTestDataInterruptFails
                                                 ofType:kTestDataShellScriptExtension
                                           subdirectory:kTestDataSubdirectory];
    NSTask *secondTask = [WCLWebWindowControllerTestsHelper taskRunningCommandPath:secondCommandPath];
    
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
    WCLPlugin *plugin = [[WCLPlugin alloc] init];
    [plugin runCommandPath:commandPath withArguments:nil inDirectoryPath:nil];
    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertEqual([webWindowControllers count], (NSUInteger)1, @"The WCLPlugin should have one WCLWebWindowController.");
    WCLWebWindowController *firstWebWindowController = webWindowControllers[0];

    [plugin runCommandPath:commandPath withArguments:nil inDirectoryPath:nil];
    webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertEqual([webWindowControllers count], (NSUInteger)2, @"The WCLPlugin should have two WCLWebWindowControllers.");
    WCLWebWindowController *secondWebWindowController = webWindowControllers[1];

    XCTAssertEqualObjects(firstWebWindowController, webWindowControllers[0], @"The first WCLWebWindowController should still be at the first index.");
    XCTAssertNotEqualObjects(firstWebWindowController, secondWebWindowController, @"The WCLWebWindowControllers should not be equal.");

    NSArray *pluginOrderedWindows = [plugin orderedWindows];
    XCTAssertTrue([pluginOrderedWindows containsObject:firstWebWindowController.window], @"The plugin ordered NSWindows should contain the first WCLWebWindowControllers NSWindow.");
    XCTAssertTrue([pluginOrderedWindows containsObject:secondWebWindowController.window], @"The plugin ordered NSWindows should contain the second WCLWebWindowControllers NSWindow.");
    NSUInteger pluginIndexOfFirst = [pluginOrderedWindows indexOfObject:firstWebWindowController.window];
    NSUInteger pluginIndexOfsecond = [pluginOrderedWindows indexOfObject:secondWebWindowController.window];

    NSArray *applicationOrderedWindows = [[NSApplication sharedApplication] orderedWindows];
    XCTAssertTrue([applicationOrderedWindows containsObject:firstWebWindowController.window], @"The application ordered NSWindows should contain the first WCLWebWindowControllers NSWindow.");
    XCTAssertTrue([applicationOrderedWindows containsObject:secondWebWindowController.window], @"The application ordered NSWindows should contain the second WCLWebWindowControllers NSWindow.");
    NSUInteger applicationIndexOfFirst = [applicationOrderedWindows indexOfObject:firstWebWindowController.window];
    NSUInteger applicationIndexOfsecond = [applicationOrderedWindows indexOfObject:secondWebWindowController.window];
    
    BOOL orderMatches = (pluginIndexOfFirst > pluginIndexOfsecond) == (applicationIndexOfFirst > applicationIndexOfsecond);
    XCTAssert(orderMatches, @"The order of the NSWindows returned by the WCLPlugin should match the order returned by the NSApplication.");
    
    // Clean up
    NSArray *tasks = [[WCLWebWindowsController sharedWebWindowsController] tasks];
    XCTAssertEqual([tasks count], (NSUInteger)2, @"There should be two NSTasks.");

    [WCLTaskTestsHelper blockUntilTasksRunAndFinish:tasks];
}

@end
