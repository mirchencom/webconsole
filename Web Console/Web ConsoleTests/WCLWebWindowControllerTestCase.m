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

- (void)tearDown
{
    [WCLWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    [super tearDown];
}

#pragma mark - Helpers

- (NSString *)stringWithContentsOfSharedTestResource:(NSString *)filename
                                       withExtension:(NSString *)extension
                                        subdirectory:(NSString *)subdirectory
{
    NSURL *fileURL = [[self class] wcl_URLForSharedTestResource:filename
                                                  withExtension:extension
                                                   subdirectory:subdirectory];
    return [self wcl_stringWithContentsOfFileURL:fileURL];
}

@end
