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

    [[self class] clearUserDefaults];
}

- (void)tearDown
{
    [[self class] clearUserDefaults];
    
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

- (void)testDefaultWebDeveloperExtras
{
    BOOL webDeveloperExtrasEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kTestDefaultWebKitDeveloperExtrasKey];
    XCTAssertEqual(webDeveloperExtrasEnabled, kTestDefaultWebKitDeveloperExtrasValue, @"The WebKitDeveloperExtras value should equal the default.");
}


+ (void)clearUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kEnvironmentDictionaryKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDefaultPreferencesSelectedTabKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kTestDefaultWebKitDeveloperExtrasKey];
}

@end
