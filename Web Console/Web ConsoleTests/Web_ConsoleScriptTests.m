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
+ (NSAppleScript *)appleScriptFromTestBundleWithName:(NSString *)name;
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
    NSAppleScript *appleScript = [[self class] appleScriptFromTestBundleWithName:kTestScriptLoadHTMLFilename];

    NSDictionary *errorInfo;
    NSAppleEventDescriptor *result = [appleScript executeAndReturnError:&errorInfo];

    STAssertNil(errorInfo, @"errorInfo should be nil.");
    
    NSInteger ID = [[[result descriptorForKeyword:'seld'] stringValue] intValue];
    BOOL windowNumberExists = [[self class] windowWithWindowNumberExists:ID];
    
    STAssertTrue(windowNumberExists, @"Window should exist.");
}



#ifndef kASAppleScriptSuite
#define kASAppleScriptSuite 'ascr'
#endif

#ifndef kASSubroutineEvent
#define kASSubroutineEvent 'psbr'
#endif

#ifndef keyASSubroutineName
#define keyASSubroutineName 'snam'
#endif

- (void)testAppleScript {

    NSAppleScript *appleScript = [[self class] appleScriptFromTestBundleWithName:@"Test Arguments"];
    
    NSAppleEventDescriptor *firstParameter = [NSAppleEventDescriptor descriptorWithString:@"Message from my app."];

    NSAppleEventDescriptor *parameters = [NSAppleEventDescriptor listDescriptor];
    [parameters insertDescriptor:firstParameter atIndex:1];

    // create the AppleEvent target
    ProcessSerialNumber psn = {0, kCurrentProcess};
    NSAppleEventDescriptor *target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber
                                                                                    bytes:&psn
                                                                                   length:sizeof(ProcessSerialNumber)];
    // create an NSAppleEventDescriptor with the script's method name to call,
    // this is used for the script statement: "on show_message(user_message)"
    // Note that the routine name must be in lower case.
    NSAppleEventDescriptor* handler = [NSAppleEventDescriptor descriptorWithString:[@"show_message" lowercaseString]];


    // create the event for an AppleScript subroutine,
    // set the method name and the list of parameters
    NSAppleEventDescriptor *event = [NSAppleEventDescriptor appleEventWithEventClass:kASAppleScriptSuite
                                             eventID:kASSubroutineEvent
                                    targetDescriptor:target
                                            returnID:kAutoGenerateReturnID
                                       transactionID:kAnyTransactionID];
    [event setParamDescriptor:handler forKeyword:keyASSubroutineName];
    [event setParamDescriptor:parameters forKeyword:keyDirectObject];


//        NSAppleEventDescriptor *result = [script executeAndReturnError:&errorInfo];
    // call the event in AppleScript
//    if (![appleScript executeAppleEvent:event error:&errors]);
//    {
//        // report any errors from 'errors'
//    }

    NSDictionary *errorInfo;
    NSAppleEventDescriptor *result = [appleScript executeAppleEvent:event error:&errorInfo];

    NSLog(@"result = %@", result);
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

+ (NSAppleScript *)appleScriptFromTestBundleWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *testLoadHTMLFileURL = [bundle URLForResource:name
                                          withExtension:kTestScriptsExtension
                                           subdirectory:kTestScriptsSubdirectory];
    
    NSDictionary *errorInfo;
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithContentsOfURL:testLoadHTMLFileURL error:&errorInfo];
    
    NSAssert(!errorInfo, @"errorInfo should be nil.");

    return appleScript;
}

@end
