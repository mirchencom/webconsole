//
//  SenTestCase+BundleResources.h
//  RubyUnitTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (BundleResources)

- (NSString *)wcl_pathForResource:(NSString *)name ofType:(NSString *)extension subdirectory:(NSString *)subdirectory;
- (NSURL *)wcl_URLForResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subdirectory;
- (NSString *)wcl_stringWithContentsOfFileURL:(NSURL *)fileURL;
+ (NSURL *)wcl_URLForSharedTestResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subdirectory;

@end
