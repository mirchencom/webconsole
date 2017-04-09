//
//  SenTestCase+BundleResources.h
//  RubyUnitTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN
@interface XCTestCase (SharedTestResources)
+ (NSURL *)wcl_sharedTestResourcesURL;
+ (NSURL *)wcl_URLForSharedTestResource:(NSString *)name
                          withExtension:(NSString *)ext
                           subdirectory:(NSString *)subdirectory;
+ (NSString *)wcl_stringWithContentsOfSharedTestResource:(NSString *)filename
                                           withExtension:(NSString *)extension
                                            subdirectory:(NSString *)subdirectory;
@end
NS_ASSUME_NONNULL_END
