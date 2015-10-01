//
//  XCTestCase+UserDefaults.h
//  Web Console
//
//  Created by Roben Kleene on 9/30/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (UserDefaults)
- (void)setUpMockUserDefaults;
- (void)tearDownMockUserDefaults;
@end
