//
//  WCLSplitWebWindowControllerResizingTests.m
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WCLSplitWebWindowControllerTestCase.h"

// Test Helpers
#import "WCLSplitWebWindowControllerTestsHelper.h"
#import "WCLTaskTestsHelper.h"
#import "WCLSplitWebWindowControllerTestsHelper.h"
// Plugins
#import "Web_Console-Swift.h"

#import "NSRectHelpers.h"
#import "Web_ConsoleTestsConstants.h"

@interface WCLSplitWebWindowControllerResizingTests : WCLSplitWebWindowControllerTestCase
+ (NSRect)savedFrameNamed:(NSString *)frameName;
@end

@implementation WCLSplitWebWindowControllerResizingTests

- (void)testResizingAndCascadingWindows
{
    WCLSplitWebWindowController *splitWebWindowController = [self makeSplitWebWindowController];
    Plugin *plugin = splitWebWindowController.plugin;
    XCTAssertEqual([[[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin] count], (NSUInteger)1, @"There should be one WCLSplitWebWindowControllers for the WCLPlugin.");
    
    // Test that the NSWindow's frame matches the saved frame
    NSRect savedFrame = [[self class] savedFrameNamed:plugin.name];
    NSRect windowFrame = [splitWebWindowController.window frame];

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
//    XCTAssertFalse([splitWebWindowController shouldCascadeWindows], @"The first WCLSplitWebWindowController for a plugin should not cascade windows.");
    
    // Set the NSWindow's frame to the destination frame
    [splitWebWindowController.window setFrame:destinationFrame display:NO];

    // Test that the saved frame now equals the destination frame
    savedFrame = [[self class] savedFrameNamed:plugin.name];
    XCTAssertTrue(NSRectEqualToRect(savedFrame, destinationFrame), @"The saved frame should equal the destination frame.");
    
    // Close the NSWindow
    [WCLSplitWebWindowControllerTestsHelper blockUntilWebWindowControllerTasksRunAndFinish:splitWebWindowController];
    [WCLSplitWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    // Open a new NSWindow
    splitWebWindowController = [self makeSplitWebWindowController];
    XCTAssertEqual([[[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin] count], (NSUInteger)1, @"There should be one WCLSplitWebWindowControllers for the WCLPlugin.");
    
    // Test that the NSWindow's frame now equals the destination frame
    windowFrame = [splitWebWindowController.window frame];
    
    XCTAssertTrue(NSSizeEqualToSize(windowFrame.size, destinationFrame.size), @"The NSWindow's frame should equal the destination frame.");
//    XCTAssertFalse([splitWebWindowController shouldCascadeWindows], @"The first WCLSplitWebWindowController for a plugin should not cascade windows.");
    // Rect check should only succeed if this WCLSplitWebWindowController should not cascade windows
//    XCTAssertTrue(NSRectEqualToRect(windowFrame, destinationFrame), @"The NSWindow's frame should equal the destination frame.");
    
    // Open a second window
    splitWebWindowController = [self makeSplitWebWindowController];
    XCTAssertEqual([[[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin] count], (NSUInteger)2, @"There should be two WCLSplitWebWindowControllers for the WCLPlugin.");
    
    // Test that the second NSWindow's frame now equals the destination frame
    windowFrame = [splitWebWindowController.window frame];
    XCTAssertTrue(NSSizeEqualToSize(windowFrame.size, destinationFrame.size), @"The NSWindow's sie should equal the destination size.");

    // TODO: Cascade windows doesn't seem to be working since converting to a storyboard
//    XCTAssertTrue([splitWebWindowController shouldCascadeWindows], @"The second WCLSplitWebWindowController for a plugin should cascade windows.");
    // Rect check should only succeed if this WCLSplitWebWindowController should not cascade windows
    BOOL testCascadeFrameComparisonResult = ![splitWebWindowController shouldCascadeWindows];
    XCTAssertEqual(NSRectEqualToRect(windowFrame, destinationFrame), testCascadeFrameComparisonResult, @"The NSWindow's frame comparison result should match the test result.");

    // Set the second NSWindow's frame to the second destination frame
    [splitWebWindowController.window setFrame:destinationFrameTwo display:NO];

    // Test that the saved frame now equals the second destination frame
    savedFrame = [[self class] savedFrameNamed:plugin.name];
    XCTAssertTrue(NSRectEqualToRect(savedFrame, destinationFrameTwo), @"The saved frame should equal the destination frame.");
    
    // Open a third NSWindow
    splitWebWindowController = [self makeSplitWebWindowController];
    XCTAssertEqual([[[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin] count], (NSUInteger)3, @"There should be three WCLSplitWebWindowControllers for the WCLPlugin.");
    
    // Test that the third NSWindow matches the second desintation frame
    windowFrame = [splitWebWindowController.window frame];
    XCTAssertTrue(NSSizeEqualToSize(windowFrame.size, destinationFrameTwo.size), @"The NSWindow's size should equal the destination size.");
    // TODO: Cascade windows doesn't seem to be working since converting to a storyboard
//    XCTAssertTrue([splitWebWindowController shouldCascadeWindows], @"The third WCLSplitWebWindowController for a plugin should cascade windows.");
    // Rect check should only succeed if this WCLSplitWebWindowController should not cascade windows
    testCascadeFrameComparisonResult = ![splitWebWindowController shouldCascadeWindows];
    XCTAssertEqual(NSRectEqualToRect(windowFrame, destinationFrameTwo), testCascadeFrameComparisonResult, @"The NSWindow's frame comparison result should match the test result.");

    // Test that the saved frame matches second destination frame
    savedFrame = [[self class] savedFrameNamed:plugin.name];
    XCTAssertTrue(NSSizeEqualToSize(savedFrame.size, destinationFrameTwo.size), @"The saved size should equal the destination size.");
    // Rect check should only succeed if this WCLSplitWebWindowController should not cascade windows
    XCTAssertEqual(NSRectEqualToRect(savedFrame, destinationFrameTwo), testCascadeFrameComparisonResult, @"The NSWindow's frame comparison result should match the test result.");

    // Clean up
    NSArray *tasks = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] tasks];
    [WCLTaskTestsHelper blockUntilTasksRunAndFinish:tasks];
}


#pragma mark - Helpers

+ (NSRect)savedFrameNamed:(NSString *)frameName
{
    NSString *key = [NSString stringWithFormat:@"NSWindow Frame %@", frameName];
    NSString *frameString = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    return NSRectFromString(frameString); // If frame string is nil, returns NSZeroRect
}

@end
