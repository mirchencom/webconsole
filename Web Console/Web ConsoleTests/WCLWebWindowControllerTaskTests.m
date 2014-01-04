//
//  WCLWebWindowControllerTaskTests.m
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLWebWindowControllerTestCase.h"

#import "WCLWebWindowControllerTestsHelper.h"

#import "WCLTaskTestsHelper.h"

#import "WCLUserInterfaceTextHelper.h"

#import "WCLPlugin+Tests.h"

#import "WCLPluginManager.h"

#import "WCLApplicationTerminationHelper.h"

#import "WCLWebWindowControllerTestsHelper.h"

@interface WCLWebWindowControllerTaskTests : WCLWebWindowControllerTestCase
+ (void)testInformativeText:(NSString *)informativeText forCommandPaths:(NSArray *)commandPaths;
@end

@implementation WCLWebWindowControllerTaskTests

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
    [WCLWebWindowControllerTestsHelper blockUntilWebWindowControllerTasksRunAndFinish:webWindowController];
}


#pragma mark - UserInterfaceTextHelper

- (void)testInformativeTextForCloseWindowForCommands
{
    NSString *informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:@[]];
    XCTAssertNil(informativeText, @"The informative text should be nil for an empty NSArray.");
    
    NSURL *pluginURL = [self wcl_URLForResource:kTestPluginName
                                  withExtension:kPlugInExtension
                                   subdirectory:kTestDataSubdirectory];
    WCLPlugin *plugin = [[WCLPluginManager sharedPluginManager] addedPluginAtURL:pluginURL];
    NSArray *commandPaths = @[[plugin commandPath]];
    informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:commandPaths];
    [[self class] testInformativeText:informativeText forCommandPaths:commandPaths];
    
    WCLPluginManager *pluginManager = [WCLPluginManager sharedPluginManager];
    NSArray *plugins = [pluginManager plugins];
    commandPaths = [plugins valueForKey:kPluginCommandPathKey];
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

@end