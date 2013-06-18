//
//  Web_ConsoleTests.m
//  Web ConsoleTests
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "Web_ConsoleTests.h"

@implementation Web_ConsoleTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

// Tests:

// 1. Test Basic load HTML
//  Run load HTML without a parameter and save the result
//  Confirm the result is a window
//  Run another script referencing the window by ID and save the result
//  Confirm the result is the same window as the original test
// 2. Run with garbage data for load HTML
//  Pass in invalid HTML
// 3. Run with garbage data for both
// 4. Run with good data for lad HTML and garbage data for the window


- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in Web ConsoleTests");
}

@end
