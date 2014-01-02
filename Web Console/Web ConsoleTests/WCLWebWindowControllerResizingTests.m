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
#warning This implementation will overwrite my real window frame data for the test plugin, so I want to use a different name here, maybe use the load plugin API and the print plugin?
    
    // For window resizing to work the plugin must have a name
    NSURL *pluginURL = [self wcl_URLForResource:kTestPluginName
                                  withExtension:kPlugInExtension
                                   subdirectory:kTestDataSubdirectory];
    WCLPlugin *plugin = [[WCLPluginManager sharedPluginManager] addedPluginAtURL:pluginURL];

    XCTAssertNotNil(plugin.name, @"The WCLPlugin should have a name.");
    XCTAssertTrue([plugin.name isEqualToString:kTestPluginName], @"The WCLPlugin's name should equal the test plugin name.");
    
    WCLWebWindowController *webWindowController = [self webWindowControllerRunningHelloWorldForPlugin:plugin];

    // Test Resizing...
    
    // Get the window frame from NSUserDefaults
    NSRect savedFrame = [[self class] savedFrameNamed:plugin.name];
NSLog(@"Original savedFrame = %@", NSStringFromRect(savedFrame));

    NSRect windowFrame = [webWindowController.window frame];
NSLog(@"First windowFrame = %@", NSStringFromRect(windowFrame));

    // Test the window frame equals the frame from NSUserDefaults
    if (!NSRectEqualToRect(savedFrame, NSZeroRect)) {
        // Only test if the first rect is equal if we've already stored a frame for this plugin
        XCTAssertTrue(NSRectEqualToRect(windowFrame, savedFrame), @"The NSWindow's frame should equal the saved frame.");
    }

    // If the window frame equals kTestWindowFrame, set the destination to kTestWindowFrameTwo
    // Otherwise set the destination to kTestWindowFrame
    // Test that the window from NSUserDefaults does not equal the destination frame

    // After running tests previously, the saved frame probably equals the
    // current frame already, so instead use the alternative rect as the
    // destination.
    NSRect destinationFrame = NSRectEqualToRect(windowFrame, kTestWindowFrame) ? kTestWindowFrameTwo : kTestWindowFrame;
    XCTAssertFalse(NSRectEqualToRect(windowFrame, destinationFrame), @"The NSWindow's frame should not equal the destination frame.");
    
    // Resize the window to the destination frame
    [webWindowController.window setFrame:destinationFrame display:NO];
    
    
    // Test that the window frame frame from NSUserDefaults now equals the destination frame
    savedFrame = [[self class] savedFrameNamed:plugin.name];
NSLog(@"After move savedFrame = %@", NSStringFromRect(savedFrame));

    XCTAssertTrue(NSRectEqualToRect(savedFrame, destinationFrame), @"The saved frame should equal the destination frame.");

    // Close the window
NSLog(@"before run tasks windowFrame = %@", NSStringFromRect([webWindowController.window frame]));
    [WCLWebWindowControllerTestsHelper blockUntilWebWindowControllersTasksRunAndFinish:webWindowController];
NSLog(@"after run tasks windowFrame = %@", NSStringFromRect([webWindowController.window frame]));
NSLog(@"savedFrame = %@", NSStringFromRect([[self class] savedFrameNamed:plugin.name]));
    [WCLWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    

    // Open a new window
NSLog(@"savedFrame before open = %@", NSStringFromRect([[self class] savedFrameNamed:plugin.name]));

    webWindowController = [self webWindowControllerRunningHelloWorldForPlugin:plugin];
    
    // Test that the window's frame now equals the destination frame
    windowFrame = [webWindowController.window frame];
NSLog(@"Frame that we moved the window too (which shoudl be the current saved frame) destinationFrame = %@", NSStringFromRect(destinationFrame));
NSLog(@"The frame the window was opened at windowFrame = %@", NSStringFromRect(windowFrame));
savedFrame = [[self class] savedFrameNamed:plugin.name];
NSLog(@"savedFrame after open = %@", NSStringFromRect(savedFrame));
    XCTAssertTrue(NSRectEqualToRect(windowFrame, destinationFrame), @"The NSWindow's frame should equal the destination frame.");
    
    // Open a second window
    
    
    
    // Clean up
    [WCLWebWindowControllerTestsHelper blockUntilWebWindowControllersTasksRunAndFinish:webWindowController];
}

#pragma mark - Helpers

- (WCLWebWindowController *)webWindowControllerRunningHelloWorldForPlugin:(WCLPlugin *)plugin
{
    // Run a simple command to get the window to display
    NSString *commandPath = [self wcl_pathForResource:kTestDataRubyHelloWorld
                                               ofType:kTestDataRubyExtension
                                         subdirectory:kTestDataSubdirectory];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    // Test the WCLWebWindowController is configured correctly
    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    NSAssert([webWindowControllers count] == (NSUInteger)1, @"The WCLPlugin should have one WebWindowController.");
    WCLWebWindowController *webWindowController = webWindowControllers[0];
    NSAssert(webWindowController.plugin == plugin, @"The WCLWebWindowController's WCLPlugin should equal the WCLPlugin.");

#warning Turning off cascading windows for tests with the assumption that "in the wild" the actual windows origins will sometimes vary due to cascading.
    [webWindowController setShouldCascadeWindows:NO];
    
    return webWindowController;
}

+ (NSRect)savedFrameNamed:(NSString *)frameName
{
    NSString *key = [NSString stringWithFormat:@"NSWindow Frame %@", frameName];
    NSString *frameString = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    return NSRectFromString(frameString); // If frame string is nil, returns NSZeroRect
}

@end
