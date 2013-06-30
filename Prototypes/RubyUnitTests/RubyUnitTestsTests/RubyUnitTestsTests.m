//
//  RubyUnitTestsTests.m
//  RubyUnitTestsTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "RubyUnitTestsTests.h"

#import "RubyTestUnit.h"

#import "SenTestCase+BundleResources.h"

#define kScriptsSubdirectory @"Scripts"
#define kRubyTestScriptDoDirectParameter @"tc_do_direct_parameter"
#define kRubyTestScriptSimpleAppleScript @"tc_simple_applescript"
#define kRubyTestScriptExtension @"rb"

@implementation RubyUnitTestsTests

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

//- (void)testDoDirectParameter
//{
//    NSURL *fileURL = [self URLForResource:kRubyTestScriptDoDirectParameter withExtension:kRubyTestScriptExtension subdirectory:kScriptsSubdirectory];
//
//    NSLog(@"fileURL = %@", fileURL);
//
//    [RubyTestUnit runTestWithContentsOfURL:fileURL completionHandler:^(BOOL success) {
//        NSLog(@"success = %i", success);
//    }];
//}
//
//- (void)testSimpleScript
//{
//    NSURL *fileURL = [self URLForResource:kRubyTestScriptSimpleAppleScript withExtension:kRubyTestScriptExtension subdirectory:kScriptsSubdirectory];
//    
//    NSLog(@"fileURL = %@", fileURL);
//    
//    [RubyTestUnit runTestWithContentsOfURL:fileURL completionHandler:^(BOOL success) {
//        NSLog(@"success = %i", success);
//    }];
//}


- (void)testDoSomething {

    NSURL *fileURL = [self URLForResource:kRubyTestScriptDoDirectParameter withExtension:kRubyTestScriptExtension subdirectory:kScriptsSubdirectory];
//    NSURL *fileURL = [self URLForResource:kRubyTestScriptSimpleAppleScript withExtension:kRubyTestScriptExtension subdirectory:kScriptsSubdirectory];


    NSLog(@"fileURL = %@", fileURL);
    
    __block BOOL hasCalledBack = NO;
    [RubyTestUnit runTestWithContentsOfURL:fileURL completionHandler:^(BOOL success) {
        NSLog(@"success = %i", success);
        NSLog(@"Completion Block!");
        hasCalledBack = YES;
    }];
    
    
    // Repeatedly process events in the run loop until we see the callback run.
    
    // This code will wait for up to 10 seconds for something to come through
    // on the main queue before it times out. If your tests need longer than
    // that, bump up the time limit. Giving it a timeout like this means your
    // tests won't hang indefinitely.
    
    // -[NSRunLoop runMode:beforeDate:] always processes exactly one event or
    // returns after timing out.
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:180];
    while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:loopUntil];
    }
    
    if (!hasCalledBack)
    {
        STFail(@"I know this will fail, thanks");
    }
}


@end
