//
//  Web_ConsoleTests.m
//  Web ConsoleTests
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "Web_ConsoleTests.h"

#import "SenTestCase+BundleResources.h"
#import "Web_ConsoleTestsConstants.h"

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

- (void)testLoadHTMLTwice
{
    NSURL *fileURL = [self URLForResource:kTestDataHTMLFilename
                            withExtension:kTestDataHTMLExtension
                             subdirectory:kTestDataSubdirectory];

NSLog(@"fileURL = %@", fileURL);
    STFail(@"Unit tests are not implemented yet in Web ConsoleTests");
}

@end
