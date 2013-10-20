//
//  SenTestCase+BundleResources.h
//  RubyUnitTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (BundleResources)

- (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subdirectory;
- (NSString *)stringWithContentsOfFileURL:(NSURL *)fileURL;

@end
