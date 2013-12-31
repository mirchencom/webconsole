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

//#define kTestWindowFrame NSRectMake(158, 97, 303, 449)
//#define kTestWindowFrameTwo NSRectMake(50, 50, 343, 409)


//bool NSRect::equals(const NSRect& rect) const
//{
//    return (origin.equals(rect.origin) &&
//            size.equals(rect.size));
//}
//
//bool NSPoint::equals(const NSPoint& target) const
//{
//    return ((x == target.x) && (y == target.y));
//}
//
//bool NSSize::equals(const NSSize& target) const
//{
//    return ((width == target.width) && (height == target.height));
//}

NS_INLINE BOOL NSSizeEqualToSize (NSSize size1, NSSize size2)
{
    return (size1.height == size2.height) && (size1.width == size2.width);
}

NS_INLINE BOOL NSPointEqualToPoint (NSPoint point1, NSPoint point2)
{
    return (point1.x == point2.x) && (point1.y == point2.y);
}

NS_INLINE BOOL NSRectEqualToRect (NSRect rect1, NSRect rect2)
{
    return NSPointEqualToPoint(rect1.origin, rect2.origin) && NSSizeEqualToSize(rect1.size, rect2.size);
}

//NS_INLINE NSRange NSMakeRange(NSUInteger loc, NSUInteger len) {
//    NSRange r;
//    r.location = loc;
//    r.length = len;
//    return r;
//}


@interface WCLWebWindowControllerResizingTests : WCLWebWindowControllerTestCase
+ (NSRect)savedFrameNamed:(NSString *)frameName;
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
    
    // Get the window frame from NSUserDefaults

    NSRect savedFrame = [[self class] savedFrameNamed:plugin.name];
    NSLog(@"savedFrame = %@", NSStringFromRect(savedFrame));

    NSRect windowFrame = [webWindowController.window frame];
    NSLog(@"windowFrame = %@", NSStringFromRect(windowFrame));
    
    XCTAssertTrue(NSRectEqualToRect(savedFrame, windowFrame), @"Rects should equal");
    // If the window frame equals kTestWindowFrame, set the destination to kTestWindowFrameTwo
    // Otherwise set the destination to kTestWindowFrame
    // Test that the window from NSUserDefaults does not equal the destination frame
    
    // Test the window frame equals the frame from NSUserDefaults
    
    // Resize the window to the destination frame

    // Test that the window frame frame from NSUserDefaults now equals the destination frame
    
    // Close the window

    // Open a new window
    
    // Test that the window's frame now equals the destination frame
    
    // Open a second window
    
    // Test that the second window also has the same frame (I'll probably have to modify this to just test the size to account for cascading)
    
    
    // Clean up
    [WCLTaskTestsHelper blockUntilTasksAreRunning:webWindowController.tasks];
    [WCLTaskTestsHelper blockUntilTasksFinish:webWindowController.tasks];
}

#pragma mark - Helpers

+ (NSRect)savedFrameNamed:(NSString *)frameName
{
    NSString *key = [NSString stringWithFormat:@"NSWindow Frame %@", frameName];
    NSString *frameString = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    return NSRectFromString(frameString);
}

@end
