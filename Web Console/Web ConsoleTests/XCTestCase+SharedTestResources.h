//
//  SenTestCase+BundleResources.h
//  RubyUnitTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (SharedTestResources)
+ (nonnull NSURL *)wcl_sharedTestResourcesURL;
+ (nonnull NSURL *)wcl_URLForSharedTestResource:(nonnull NSString *)name
                          withExtension:(nonnull NSString *)ext
                           subdirectory:(nonnull NSString *)subdirectory;
+ (nonnull NSString *)wcl_stringWithContentsOfSharedTestResource:(nonnull NSString *)filename
                                           withExtension:(nonnull NSString *)extension
                                            subdirectory:(nonnull NSString *)subdirectory;
@end
