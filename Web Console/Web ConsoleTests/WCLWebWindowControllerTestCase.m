//
//  WCLWebWindowControllerTestCase.m
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLWebWindowControllerTestCase.h"

#import "WCLWebWindowControllerTestsHelper.h"

@implementation WCLWebWindowControllerTestCase

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    [WCLWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    [super tearDown];
}

#pragma mark - Helpers

- (NSString *)stringWithContentsOfTestDataFilename:(NSString *)filename extension:(NSString *)extension {
    NSURL *fileURL = [self wcl_URLForResource:filename
                                withExtension:extension
                                 subdirectory:kTestDataSubdirectory];
    return [self wcl_stringWithContentsOfFileURL:fileURL];
}

@end
