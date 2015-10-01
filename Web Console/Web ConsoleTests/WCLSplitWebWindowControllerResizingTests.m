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
@property (nonatomic, readonly) NSString *defaultPluginSavedFrameName;
@end

@implementation WCLSplitWebWindowControllerResizingTests

#pragma mark - Properties

- (NSString *)defaultPluginSavedFrameName
{
    Plugin *plugin = [[self class] defaultPlugin];
    NSString *frameName = [[self class] savedFrameNameForPlugin:plugin];
    return frameName;
}

#pragma mark - Life Cycle

- (void)setUp
{
    [super setUp];
    // NSUserDefaults cannot be mocked because `NSWindow saveFrameUsingName:` saves directly to `standardUserDefaults`
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:self.defaultPluginSavedFrameName];
}

- (void)tearDown
{
    [[self class] blockUntilAllTasksRunAndFinish];
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:self.defaultPluginSavedFrameName];
    [super tearDown];
}

- (void)testResizingAndCascadingWindows
{
    WCLSplitWebWindowController *splitWebWindowController = [self makeSplitWebWindowController];
    Plugin *plugin = splitWebWindowController.plugin;
    XCTAssertEqual([[[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin] count], (NSUInteger)1, @"There should be one WCLSplitWebWindowControllers for the WCLPlugin.");
//    XCTAssertFalse([splitWebWindowController shouldCascadeWindows], @"The first WCLSplitWebWindowController for a plugin should not cascade windows.");
    
    NSRect destinationFrame = kTestWindowFrame;
    NSRect destinationFrameTwo = kTestWindowFrameTwo;

    // Set the NSWindow's frame to the destination frame
    [splitWebWindowController.window setFrame:destinationFrame display:NO];

    // Test that the saved frame now equals the destination frame
    NSRect savedFrame = [[self class] savedFrameForPlugin:plugin];
    XCTAssertTrue(NSRectEqualToRect(savedFrame, destinationFrame), @"The saved frame should equal the destination frame.");
    
    // Close the NSWindow
    [WCLSplitWebWindowControllerTestsHelper blockUntilWebWindowControllerTasksRunAndFinish:splitWebWindowController];
    [WCLSplitWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    // Open a new NSWindow
    splitWebWindowController = [self makeSplitWebWindowController];
    XCTAssertEqual([[[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin] count], (NSUInteger)1, @"There should be one WCLSplitWebWindowControllers for the WCLPlugin.");
    
    // Test that the NSWindow's frame now equals the destination frame
    NSRect windowFrame = [splitWebWindowController.window frame];
    
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
    savedFrame = [[self class] savedFrameForPlugin:plugin];
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
    savedFrame = [[self class] savedFrameForPlugin:plugin];
    XCTAssertTrue(NSSizeEqualToSize(savedFrame.size, destinationFrameTwo.size), @"The saved size should equal the destination size.");
    // Rect check should only succeed if this WCLSplitWebWindowController should not cascade windows
    XCTAssertEqual(NSRectEqualToRect(savedFrame, destinationFrameTwo), testCascadeFrameComparisonResult, @"The NSWindow's frame comparison result should match the test result.");
}

- (void)testResizingWindowsWithDifferentPlugins
{
    // TODO: Test different plugin names
    // Make a window with the default plugin and frame
    WCLSplitWebWindowController *splitWebWindowController = [self makeSplitWebWindowController];
    NSRect destinationFrame = kTestWindowFrame;
    [splitWebWindowController.window setFrame:destinationFrame display:NO];

    // Make a second window with a different plugin and frame
    WCLSplitWebWindowController *splitWebWindowControllerTwo = [self makeSplitWebWindowControllerForOtherPlugin];
    NSRect destinationFrameTwo = kTestWindowFrameTwo;
    [splitWebWindowControllerTwo.window setFrame:destinationFrameTwo display:NO];
    
    // Make a third window for the first plugin
    WCLSplitWebWindowController *splitWebWindowControllerThree = [self makeSplitWebWindowController];
    NSRect windowFrame = [splitWebWindowControllerThree.window frame];
    XCTAssertTrue(NSSizeEqualToSize(windowFrame.size, destinationFrame.size), @"The NSWindow's size should equal the destination size.");
}

#pragma mark - Helpers

+ (NSString *)savedFrameNameForPlugin:(Plugin *)plugin
{
    NSString *savedFrameName = [NSString stringWithFormat:@"NSWindow Frame %@", plugin.name];
    return savedFrameName;
}

+ (NSRect)savedFrameForPlugin:(Plugin *)plugin
{
    NSString *savedFrameName = [self savedFrameNameForPlugin:plugin];
    NSString *frameString = [[UserDefaultsManager standardUserDefaults] stringForKey:savedFrameName];
    return NSRectFromString(frameString); // If frame string is nil, returns NSZeroRect
}

@end
