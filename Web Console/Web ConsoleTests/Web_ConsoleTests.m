//
//  Web_ConsoleTests.m
//  Web ConsoleTests
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "Web_ConsoleTests.h"

#import "SenTestCase+BundleResources.h"
#import "Web_ConsoleTestsConstants.h"

#import "WebWindowsController.h"
#import "WebWindowController.h"

@implementation Web_ConsoleTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testLoadHTMLWithBaseURL {
    NSURL *fileURL = [self URLForResource:kTestDataHTMLJQUERYFilename
                            withExtension:kTestDataHTMLExtension
                             subdirectory:kTestDataSubdirectory];
    NSString *HTML = [self stringWithContentsOfFileURL:fileURL];
    NSURL *baseURL = [fileURL URLByDeletingLastPathComponent];

    __block BOOL completionHandlerRan = NO;
    WebWindowController *webWindowController = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];
    [webWindowController loadHTML:HTML baseURL:baseURL completionHandler:^(BOOL success) {
        completionHandlerRan = YES;
    }];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeout];
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
        if (completionHandlerRan) break;
    }
	
    STAssertTrue(completionHandlerRan, @"completionHandler did not run.");

    NSString *javaScript = [self stringWithContentsOfTestDataFilename:kTestJQueryJavaScriptFilename
                                                            extension:kTestDataJavaScriptExtension];
    
    NSString *result = [webWindowController doJavaScript:javaScript];

    NSLog(@"result = %@", result);
    STAssertNotNil(result, @"Result should not be nil.");
}

- (void)testLoadHTMLTwice
{
    NSString *HTML = [self stringWithContentsOfTestDataFilename:kTestDataHTMLFilename extension:kTestDataHTMLExtension];
    
    WebWindowController *webWindowController = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];

    __block BOOL completionHandlerRan1 = NO;
    [webWindowController loadHTML:HTML completionHandler:^(BOOL success) {
        completionHandlerRan1 = YES;
        STAssertFalse(success, @"The first load should fail.");
    }];

    __block BOOL completionHandlerRan2 = NO;
    [webWindowController loadHTML:HTML completionHandler:^(BOOL success) {
        completionHandlerRan2 = YES;
        STAssertTrue(success, @"The second load should succeed.");
    }];
		
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeout];
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
        if (completionHandlerRan1 && completionHandlerRan2) break;
    }
	
    STAssertTrue(completionHandlerRan1, @"completionHandler1 did not run.");
    STAssertTrue(completionHandlerRan2, @"completionHandler2 did not run.");    
}

#pragma mark - Helpers

- (NSString *)stringWithContentsOfTestDataFilename:(NSString *)filename extension:(NSString *)extension {
    NSURL *fileURL = [self URLForResource:filename
                            withExtension:extension
                             subdirectory:kTestDataSubdirectory];
    return [self stringWithContentsOfFileURL:fileURL];
}


@end
