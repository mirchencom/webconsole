//
//  Web_ConsoleTests.m
//  Web Console
//
//  Created by Roben Kleene on 4/13/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Web_ConsoleTestsConstants.h"

#import "WCLPreferencesWindowController.h"

@interface Web_ConsoleTests : XCTestCase

@end

@implementation Web_ConsoleTests

- (void)setUp
{
    [super setUp];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kEnvironmentDictionaryKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultPreferencesSelectedTabKey];
}

- (void)tearDown
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kEnvironmentDictionaryKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultPreferencesSelectedTabKey];

    [super tearDown];
}

- (void)testDefaultPreferencePane
{
    WCLPreferencePane preferencePane = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultPreferencesSelectedTabKey];;

    XCTAssertEqual(preferencePane, kTestDefaultPreferencesSelectedTabValue, @"The WCLPreferencePane should equal the default WCLPreferencePane.");
}

- (void)testDefaultEnvironment
{
    NSDictionary *environmentDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kEnvironmentDictionaryKey];
    
    NSString *path = environmentDictionary[kTestDefaultEnvironmentVariablePathKey];
    XCTAssertTrue([path isEqualToString:kTestDefaultEnvironmentVariablePathValue], @"The path should equal the default path.");
    
    NSString *encoding = environmentDictionary[kTestDefaultEnvironmentVariableEncodingKey];
    XCTAssertTrue([encoding isEqualToString:kTestDefaultEnvironmentVariableEncodingValue], @"The encoding should equal the default encoding.");
}

@end
