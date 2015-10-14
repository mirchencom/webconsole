//
//  XCTestCase+UserDefaults.m
//  Web Console
//
//  Created by Roben Kleene on 9/30/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

#import "XCTestCase+UserDefaults.h"
#import "WebConsoleConstants.h"
#import "Web_Console-Swift.h"

#define kTestMockUserDefaultsSuiteName @"com.1percenter.WebConsoleTests"

@implementation XCTestCase (UserDefaults)

- (void)setUpMockUserDefaults
{
    NSURL *userDefaultsURL = [[NSBundle mainBundle] URLForResource:kUserDefaultsFilename
                                                     withExtension:kUserDefaultsFileExtension];
    NSMutableDictionary *userDefaultsDictionary = [NSMutableDictionary dictionaryWithContentsOfURL:userDefaultsURL];
    userDefaultsDictionary[kDebugModeEnabledKey] = @NO;
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:kTestMockUserDefaultsSuiteName];
    [userDefaults registerDefaults:userDefaultsDictionary];
    NSUserDefaultsController *userDefaultsController = [[NSUserDefaultsController alloc] initWithDefaults:userDefaults initialValues:userDefaultsDictionary];
    
    [UserDefaultsManager setOverrideStandardUserDefaults:userDefaults];
    [UserDefaultsManager setOverrideSharedUserDefaultsController:userDefaultsController];
}

- (void)tearDownMockUserDefaults
{
    [UserDefaultsManager setOverrideStandardUserDefaults:nil];
    [UserDefaultsManager setOverrideSharedUserDefaultsController:nil];
}


@end
