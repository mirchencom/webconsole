//
//  WCLWebWindowControllerResizingTests.m
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WCLWebWindowControllerTestCase.h"

// Test Helpers
#import "WCLWebWindowControllerTestsHelper.h"
#import "WCLTaskTestsHelper.h"
// Plugins
#import "WCLPlugin+Tests.h"
#import "WCLPluginManager.h"

#import "NSRectHelpers.h"

@interface WCLWebWindowControllerResizingTests : WCLWebWindowControllerTestCase
+ (NSRect)savedFrameNamed:(NSString *)frameName;
- (WCLWebWindowController *)webWindowControllerRunningHelloWorldForPlugin:(WCLPlugin *)plugin;
@end

@implementation WCLWebWindowControllerResizingTests

- (void)testResizingWindow
{
    NSURL *pluginURL = [[self class] wcl_URLForSharedTestResource:kTestPluginName
                                                    withExtension:kPlugInExtension
                                                     subdirectory:kSharedTestResourcesPluginSubdirectory];
    WCLPlugin *plugin = [[WCLPluginManager sharedPluginManager] addedPluginAtURL:pluginURL];

    // The plugin needs a name for saved frames to work
    XCTAssertNotNil(plugin.name, @"The WCLPlugin should have a name.");
    XCTAssertTrue([plugin.name isEqualToString:kTestPluginName], @"The WCLPlugin's name should equal the test plugin name.");
    
    // Open an NSWindow
    WCLWebWindowController *webWindowController = [self webWindowControllerRunningHelloWorldForPlugin:plugin];
    XCTAssertEqual([[[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin] count], (NSUInteger)1, @"There should be one WCLWebWindowControllers for the WCLPlugin.");

    // Test that the NSWindow's frame matches the saved frame
    NSRect savedFrame = [[self class] savedFrameNamed:plugin.name];
    NSRect windowFrame = [webWindowController.window frame];
    if (!NSRectEqualToRect(savedFrame, NSZeroRect)) {
        // Only test if the first rect is equal if we've already stored a frame for this plugin
        XCTAssertTrue(NSRectEqualToRect(windowFrame, savedFrame), @"The NSWindow's frame should equal the saved frame.");
    }

    // Setup the destination frames
    // After running tests previously, the saved frame probably equals the
    // current frame already, so instead use the alternative rect as the
    // destination.
    NSRect destinationFrame = NSRectEqualToRect(windowFrame, kTestWindowFrame) ? kTestWindowFrameTwo : kTestWindowFrame;
    NSRect destinationFrameTwo = NSRectEqualToRect(windowFrame, kTestWindowFrame) ? kTestWindowFrame : kTestWindowFrameTwo;
    XCTAssertFalse(NSRectEqualToRect(windowFrame, destinationFrame), @"The NSWindow's frame should not equal the destination frame.");
    XCTAssertFalse(NSRectEqualToRect(destinationFrame, destinationFrameTwo), @"The NSWindow's frame should not equal the destination frame.");
    
    // Set the NSWindow's frame to the destination frame
    [webWindowController.window setFrame:destinationFrame display:NO];

    // Test that the saved frame now equals the destination frame
    savedFrame = [[self class] savedFrameNamed:plugin.name];
    XCTAssertTrue(NSRectEqualToRect(savedFrame, destinationFrame), @"The saved frame should equal the destination frame.");

    // Close the NSWindow
    [WCLWebWindowControllerTestsHelper blockUntilWebWindowControllerTasksRunAndFinish:webWindowController];
    [WCLWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    // Open a new NSWindow
    webWindowController = [self webWindowControllerRunningHelloWorldForPlugin:plugin];
    XCTAssertEqual([[[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin] count], (NSUInteger)1, @"There should be one WCLWebWindowControllers for the WCLPlugin.");
    
    // Test that the NSWindow's frame now equals the destination frame
    windowFrame = [webWindowController.window frame];
    
    XCTAssertTrue(NSSizeEqualToSize(windowFrame.size, destinationFrame.size), @"The NSWindow's frame should equal the destination frame.");
//    XCTAssertTrue(NSRectEqualToRect(windowFrame, destinationFrame), @"The NSWindow's frame should equal the destination frame.");
    
    // Open a second window
    webWindowController = [self webWindowControllerRunningHelloWorldForPlugin:plugin];
    XCTAssertEqual([[[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin] count], (NSUInteger)2, @"There should be two WCLWebWindowControllers for the WCLPlugin.");
    
    // Test that the second NSWindow's frame now equals the destination frame
    windowFrame = [webWindowController.window frame];
    XCTAssertTrue(NSSizeEqualToSize(windowFrame.size, destinationFrame.size), @"The NSWindow's sie should equal the destination size.");
    // Rect check fails due to cascading
//    XCTAssertTrue(NSRectEqualToRect(windowFrame, destinationFrame), @"The NSWindow's frame should equal the destination frame.");

    // Set the second NSWindow's frame to the second destination frame
    [webWindowController.window setFrame:destinationFrameTwo display:NO];

    // Test that the saved frame now equals the second destination frame
    savedFrame = [[self class] savedFrameNamed:plugin.name];
    XCTAssertTrue(NSRectEqualToRect(savedFrame, destinationFrameTwo), @"The saved frame should equal the destination frame.");
    
    // Open a third NSWindow
    webWindowController = [self webWindowControllerRunningHelloWorldForPlugin:plugin];
    XCTAssertEqual([[[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin] count], (NSUInteger)3, @"There should be three WCLWebWindowControllers for the WCLPlugin.");
    
    // Test that the third NSWindow matches the second desintation frame
    windowFrame = [webWindowController.window frame];
    XCTAssertTrue(NSSizeEqualToSize(windowFrame.size, destinationFrameTwo.size), @"The NSWindow's size should equal the destination size.");
    // Rect check fails due to cascading
//    XCTAssertTrue(NSRectEqualToRect(windowFrame, destinationFrameTwo), @"The NSWindow's frame should equal the destination frame.");

    // Test that the saved frame matches second destination frame
    savedFrame = [[self class] savedFrameNamed:plugin.name];
    XCTAssertTrue(NSSizeEqualToSize(savedFrame.size, destinationFrameTwo.size), @"The saved size should equal the destination size.");
    // Rect check fails due to cascading
//    XCTAssertTrue(NSRectEqualToRect(savedFrame, destinationFrameTwo), @"The saved frame should equal the destination frame.");

    // Clean up
    NSArray *tasks = [[WCLWebWindowsController sharedWebWindowsController] tasks];
    [WCLTaskTestsHelper blockUntilTasksRunAndFinish:tasks];
}

#pragma mark - Helpers

- (WCLWebWindowController *)webWindowControllerRunningHelloWorldForPlugin:(WCLPlugin *)plugin
{
    NSArray *originalWebWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    
    // Run a simple command to get the window to display
    NSString *commandPath = [self wcl_pathForResource:kTestDataRubyHelloWorld
                                               ofType:kTestDataRubyExtension
                                         subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil inDirectoryPath:nil];
    
    NSMutableArray *webWindowControllers = [[[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin] mutableCopy];
    [webWindowControllers removeObjectsInArray:originalWebWindowControllers];
    
    NSAssert([webWindowControllers count] == (NSUInteger)1, @"The WCLPlugin should have one WebWindowController.");
    WCLWebWindowController *webWindowController = webWindowControllers[0];
    NSAssert(webWindowController.plugin == plugin, @"The WCLWebWindowController's WCLPlugin should equal the WCLPlugin.");
    
    return webWindowController;
}

+ (NSRect)savedFrameNamed:(NSString *)frameName
{
    NSString *key = [NSString stringWithFormat:@"NSWindow Frame %@", frameName];
    NSString *frameString = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    return NSRectFromString(frameString); // If frame string is nil, returns NSZeroRect
}

@end
