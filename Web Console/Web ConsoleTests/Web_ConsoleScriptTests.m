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
    
    NSLog(@"testLoadHTMLFileURL = %@", testLoadHTMLFileURL);

    NSLog(@"break");
    
//    NSString *scriptSource = @"load HTML \"HTML\"";
//    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptSource];

    NSDictionary *errorInfo;
    NSAppleScript *script = [[NSAppleScript alloc] initWithContentsOfURL:testLoadHTMLFileURL error:&errorInfo];

    NSLog(@"errorInfo = %@", errorInfo);
    
    NSAppleEventDescriptor *result = [script executeAndReturnError:&errorInfo];

    NSLog(@"errorInfo = %@", errorInfo);

    NSLog(@"result = %@", result);

    NSLog(@"windows = %@", [[NSApplication sharedApplication] windows]);
    
    for (NSWindow *aWindow in [[NSApplication sharedApplication] windows]) {
        NSLog(@"[aWindow windowNumber] = %li", (long)[aWindow windowNumber]);
    }
    
//    <NSAppleEventDescriptor: 'obj '{ 'form':'ID  ', 'want':'cwin', 'seld':59227, 'from':null() }>
  
// Try taking this returned data and see if I can use the Scripting Bridge to get that window?
    
//    unsigned long i = 1;
//    for (i=1; i <= [result numberOfItems]; i++) {
//		AEKeyword keyword = [result keywordForDescriptorAtIndex:i];
//
//        NSString *key = nil;
//        // This is a short list of Applescript keywords.  If it's not in this list, then we use the 4 char code.
//        switch (keyword) {
//            case 'pnam': key = @"name"; break;
//            case 'url ': key = @"url"; break;
//            case 'kywd': key = @"keyword"; break;
//            case 'pALL': key = @"properties"; break;
//            case 'capp': key = @"application"; break;
//            case 'cwin': key = @"window"; break;
//            case 'cmnu': key = @"menu"; break;
//            case 'TEXT': key = @"string"; break;
//            case 'reco': key = @"record"; break;
//            case 'nmbr': key = @"number"; break;
//        }
//
//        NSLog(@"key = %@", key);
//    }
    
    
//    NSError *error;
//    NSUserAppleScriptTask *appleScriptTask = [[NSUserAppleScriptTask alloc] initWithURL:testLoadHTMLFileURL
//                                                                                  error:&error];
//    appleScriptTask executeWithAppleEvent:nil completionHandler:
    
}

@end
