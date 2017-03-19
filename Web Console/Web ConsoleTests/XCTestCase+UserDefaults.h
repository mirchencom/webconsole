//
//  XCTestCase+UserDefaults.h
//  Web Console
//
//  Created by Roben Kleene on 9/30/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN
@interface XCTestCase (UserDefaults)
- (void)setUpMockUserDefaults;
- (void)tearDownMockUserDefaults;
@end
NS_ASSUME_NONNULL_END
