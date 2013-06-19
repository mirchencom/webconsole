//
//  Web_ConsoleScriptTests.m
//  Web Console
//
//  Created by Roben Kleene on 6/17/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "Web_ConsoleScriptTests.h"

#define kTestScriptsSubdirectory @"TestScripts"
#define kTestScriptsExtension @"scpt"
#define kTestScriptLoadHTMLFilename @"Test Load HTML"

@interface Web_ConsoleScriptTests ()
+ (BOOL)windowWithWindowNumberExists:(NSInteger)windowNumber;
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
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];

    NSLog(@"[bundle resourcePath] = %@", [bundle resourcePath]);

    NSURL *testLoadHTMLFileURL = [bundle URLForResource:kTestScriptLoadHTMLFilename
                                          withExtension:kTestScriptsExtension
                                           subdirectory:kTestScriptsSubdirectory];
    
    NSDictionary *errorInfo;
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:testLoadHTMLFileURL error:&errorInfo];

    STAssertNil(errorInfo, @"errorInfo should be nil.");
    
    NSAppleEventDescriptor *result = [script executeAndReturnError:&errorInfo];
    NSInteger ID = [[[result descriptorForKeyword:'seld'] stringValue] intValue];
    BOOL windowNumberExists = [[self class] windowWithWindowNumberExists:ID];

    STAssertNil(errorInfo, @"errorInfo should be nil.");
    
    STAssertTrue(windowNumberExists, @"Window should exist.");    
}

#pragma mark - Helpers

+ (BOOL)windowWithWindowNumberExists:(NSInteger)windowNumber {
    BOOL windowExists = NO;
    
    for (NSWindow *aWindow in [[NSApplication sharedApplication] windows]) {
        if ([aWindow windowNumber] == windowNumber) {
            windowExists = YES;
            break;
        }
    }

    return windowExists;
}



@end
