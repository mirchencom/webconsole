//
//  SenTestCase+BundleResources.m
//  RubyUnitTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "SenTestCase+BundleResources.h"

@implementation SenTestCase (BundleResources)

- (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subdirectory {
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:name
                                                              withExtension:ext
                                                               subdirectory:subdirectory];
    NSAssert(fileURL, @"fileURL should not be nil.");
    return fileURL;
}

- (NSString *)stringWithContentsOfFileURL:(NSURL *)fileURL {
    NSError *error;
    NSString *contents = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    NSString *errorMessage = [NSString stringWithFormat:@"Error loading string %@", error];
    NSAssert(!error, errorMessage);
    return contents;
}

@end