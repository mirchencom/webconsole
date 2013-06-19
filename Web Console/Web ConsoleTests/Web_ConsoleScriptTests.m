//
//  Web_ConsoleScriptTests.m
//  Web Console
//
//  Created by Roben Kleene on 6/17/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "Web_ConsoleScriptTests.h"
#import "AppleScriptHelper.h"

#import "Web_ConsoleTestsConstants.h"

#import "WebWindowController.h"

@interface Web_ConsoleScriptTests ()
+ (WebWindowController *)webWindowControllerForWindowWithWindowNumber:(NSInteger)windowNumber;
@end

@implementation Web_ConsoleScriptTests

// Tests:

// 1. Test Basic load HTML
//  Run load HTML without a parameter and save the result
//  Confirm the result is a window
//  Run another script referencing the window by ID and save the result
//  Confirm the result is the same window as the original test
// 2. Run with garbage data for load HTML
//  Pass in invalid HTML
// 3. Run with garbage data for both
// 4. Run with good data for lad HTML and garbage data for the window

- (void)testLoadHTML
{
    NSURL *HTMLFileURL = [Web_ConsoleTests fileURLForTestResource:kTestHTMLFilename withExtension:kTestHTMLExtension];

    NSError *error;
    NSString *HTML = [NSString stringWithContentsOfURL:HTMLFileURL encoding:NSUTF8StringEncoding error:&error];
    NSString *errorMessage = [NSString stringWithFormat:@"Error loading HTML string %@", error];
    STAssertNil(error, errorMessage);

    NSAppleEventDescriptor *firstParameter = [NSAppleEventDescriptor descriptorWithString:HTML];
    NSAppleEventDescriptor *parameters = [NSAppleEventDescriptor listDescriptor];
    [parameters insertDescriptor:firstParameter atIndex:1];
    
    NSAppleEventDescriptor *result = [AppleScriptHelper resultOfRunningTestScriptWithName:@"Load HTML"
                                                                               parameters:parameters];
    NSInteger windowNumber = [[[result descriptorForKeyword:'seld'] stringValue] intValue];
    WebWindowController *webWindowController = [Web_ConsoleScriptTests webWindowControllerForWindowWithWindowNumber:windowNumber];

    errorMessage = [NSString stringWithFormat:@"WebWindowController doesn't exist with windowNumber %li", (long)windowNumber];
    STAssertNotNil(webWindowController, errorMessage);
    
    WebView *webView = (WebView *)[webWindowController valueForKey:@"webView"];
    NSString *source = [(DOMHTMLElement *)[[[webView mainFrame] DOMDocument] documentElement] outerHTML];
    NSLog(@"Source = %@", source);
}

- (void)testAppleScript {
    NSString *message = @"Message from my app.";
    NSAppleEventDescriptor *firstParameter = [NSAppleEventDescriptor descriptorWithString:message];
    NSAppleEventDescriptor *parameters = [NSAppleEventDescriptor listDescriptor];
    [parameters insertDescriptor:firstParameter atIndex:1];

    NSAppleEventDescriptor *result = [AppleScriptHelper resultOfRunningTestScriptWithName:@"Test Arguments" parameters:parameters];
    NSString *resultMessage = [result stringValue];
    
    STAssertTrue([message isEqualToString:resultMessage], @"Result string doesn't match");
}

#pragma mark - Helpers

+ (WebWindowController *)webWindowControllerForWindowWithWindowNumber:(NSInteger)windowNumber {
    WebWindowController *webWindowController;    
    for (NSWindow *aWindow in [[NSApplication sharedApplication] windows]) {
        if ([aWindow windowNumber] == windowNumber) {
            webWindowController = (WebWindowController *)[aWindow windowController];
            break;
        }
    }
    return webWindowController;
}

@end