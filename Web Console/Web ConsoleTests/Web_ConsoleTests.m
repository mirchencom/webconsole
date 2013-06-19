//
//  Web_ConsoleTests.m
//  Web ConsoleTests
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "Web_ConsoleTests.h"
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

- (void)testExample
{
    

//    STFail(@"Unit tests are not implemented yet in Web ConsoleTests");
}

#pragma mark - Helpers

+ (NSURL *)fileURLForTestResource:(NSString *)name withExtension:(NSString *)ext {
    return [[NSBundle bundleForClass:[Web_ConsoleTests class]] URLForResource:name
                                                                withExtension:ext
                                                                 subdirectory:kTestScriptsSubdirectory];
}

@end
