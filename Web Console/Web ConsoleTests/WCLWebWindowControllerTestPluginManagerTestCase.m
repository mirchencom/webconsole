//
//  WCLWebWindowControllerTestPluginManagerTestCase.m
//  Web Console
//
//  Created by Roben Kleene on 2/8/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "WCLWebWindowControllerTestPluginManagerTestCase.h"
#import "Web_Console-Swift.h"


@implementation WCLWebWindowControllerTestPluginManagerTestCase

- (void)setUp
{
    [super setUp];
    
    Plugin *plugin = [[PluginsManager sharedInstance] pluginWithName:kSharedTestResourcesPluginName];
    NSURL *resourceURL = [plugin resourceURL];
    NSURL *testPluginsURL = [resourceURL URLByAppendingPathComponent:kSharedTestResourcesPluginSubdirectory];
    
    NSError *error;
    NSURL *trashURL = [[NSFileManager defaultManager] URLForDirectory:NSTrashDirectory
                                                             inDomain:NSUserDomainMask
                                                    appropriateForURL:nil
                                                               create:NO
                                                                error:&error];
    XCTAssertNil(error, @"The error should be nil");
    PluginsManager *pluginsManager = [[PluginsManager alloc] init:@[testPluginsURL]
                           duplicatePluginDestinationDirectoryURL:trashURL];
    
    [PluginsManager setOverrideSharedInstance:pluginsManager];
}

- (void)tearDown
{
    [super tearDown];
    [PluginsManager setOverrideSharedInstance:nil];
}

@end
