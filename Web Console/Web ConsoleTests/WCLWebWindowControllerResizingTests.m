//
//  WCLWebWindowControllerResizingTests.m
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WCLWebWindowControllerTestCase.h"

#import "WCLTaskTestsHelper.h"

#import "WCLPlugin+Tests.h"

#import "WCLPluginManager.h"

@interface WCLWebWindowControllerResizingTests : WCLWebWindowControllerTestCase

@end

@implementation WCLWebWindowControllerResizingTests

//- (void)setUp
//{
//    [super setUp];
//}
//
//- (void)tearDown
//{
//    [super tearDown];
//}

- (void)testResizingWindow
{
    // For window resizing to work the plugin must have a name
    WCLPlugin *plugin = [[WCLPluginManager sharedPluginManager] pluginWithName:kTestPluginName];
    XCTAssertNotNil(plugin.name, @"The WCLPlugin should have a name.");
    XCTAssertTrue([plugin.name isEqualToString:kTestPluginName], @"The WCLPlugin's name should equal the test plugin name.");

    // Run a simple command to get the window to display
    NSString *commandPath = [self wcl_pathForResource:kTestDataRubyHelloWorld
                                               ofType:kTestDataRubyExtension
                                         subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];

    // Test the WCLWebWindowController is configured correctly
    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    XCTAssertEqual([webWindowControllers count], (NSUInteger)1, @"The WCLPlugin should have one WebWindowController.");
    WCLWebWindowController *webWindowController = webWindowControllers[0];
    XCTAssertEqual(webWindowController.plugin, plugin, @"The WCLWebWindowController's WCLPlugin should equal the WCLPlugin.");
    
    // Test Resizing...
    
    // Clean up
    [WCLTaskTestsHelper blockUntilTasksAreRunning:webWindowController.tasks];
    [WCLTaskTestsHelper blockUntilTasksFinish:webWindowController.tasks];
}

@end
