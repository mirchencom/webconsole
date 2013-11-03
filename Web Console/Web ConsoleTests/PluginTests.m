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

#import "Plugin.h"

@interface Plugin (TestingAdditions)
- (void)runCommandPath:(NSString *)commandPath
         withArguments:(NSArray *)arguments
      withResourcePath:(NSString *)resourcePath
       inDirectoryPath:(NSString *)directoryPath;
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


#ifdef kRunLongTests
- (void)testCloseWindowWithRunningTask
{
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
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (![webWindowController.window attachedSheet] && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    
    [PluginTestsHelper blockUntilTaskFinishes:task timeoutInterval:kTestLongTimeoutInterval];
    
    [WebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertTrue(![webWindowControllers count], @"The plugin should not have a webWindowController");
}
#endif

@end
