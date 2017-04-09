//
//  SenTestCase+BundleResources.h
//  RubyUnitTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN
@interface XCTestCase (BundleResources)
- (nullable NSString *)wcl_pathForResource:(nullable NSString *)name ofType:(nullable NSString *)extension subdirectory:(nullable NSString *)subdirectory;
- (nullable NSURL *)wcl_URLForResource:(nullable NSString *)name withExtension:(nullable NSString *)ext subdirectory:(nullable NSString *)subdirectory;
+ (nullable NSString *)wcl_stringWithContentsOfFileURL:(NSURL *)fileURL;
@end
NS_ASSUME_NONNULL_END
