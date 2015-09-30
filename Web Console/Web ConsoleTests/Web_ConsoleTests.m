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

#import "Web_Console-Swift.h"

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
    WCLPreferencePane preferencePane = [[UserDefaultsManager standardUserDefaults] integerForKey:kDefaultPreferencesSelectedTabKey];;

    XCTAssertEqual(preferencePane, kTestDefaultPreferencesSelectedTabValue, @"The WCLPreferencePane should equal the default WCLPreferencePane.");
}

- (void)testDefaultEnvironment
{
    NSDictionary *environmentDictionary = [[UserDefaultsManager standardUserDefaults] dictionaryForKey:kEnvironmentDictionaryKey];
    
    NSString *path = environmentDictionary[kTestDefaultEnvironmentVariablePathKey];
    XCTAssertTrue([path isEqualToString:kTestDefaultEnvironmentVariablePathValue], @"The path should equal the default path.");
    
    NSString *encoding = environmentDictionary[kTestDefaultEnvironmentVariableEncodingKey];
    XCTAssertTrue([encoding isEqualToString:kTestDefaultEnvironmentVariableEncodingValue], @"The encoding should equal the default encoding.");
}

- (void)testDefaultWebDeveloperExtras
{
    BOOL webDeveloperExtrasEnabled = [[UserDefaultsManager standardUserDefaults] boolForKey:kTestDefaultWebKitDeveloperExtrasKey];
    XCTAssertEqual(webDeveloperExtrasEnabled, kTestDefaultWebKitDeveloperExtrasValue, @"The WebKitDeveloperExtras value should equal the default.");
}


+ (void)clearUserDefaults
{
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:kEnvironmentDictionaryKey];
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:kDefaultPreferencesSelectedTabKey];
    [[UserDefaultsManager standardUserDefaults] removeObjectForKey:kTestDefaultWebKitDeveloperExtrasKey];
}

@end
