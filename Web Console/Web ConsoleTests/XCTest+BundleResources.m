//
//  SenTestCase+BundleResources.m
//  RubyUnitTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "XCTest+BundleResources.h"

#import "Web_Console-Swift.h"
#import "Web_ConsoleTestsConstants.h"


@implementation XCTestCase (BundleResources)

- (NSString *)wcl_pathForResource:(NSString *)name ofType:(NSString *)extension subdirectory:(NSString *)subdirectory
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:name
                                                                      ofType:extension
                                                                 inDirectory:subdirectory];
    NSAssert(path, @"The path should not be nil.");
    return path;
}

- (NSURL *)wcl_URLForResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subdirectory
{
    NSURL *fileURL = [[NSBundle bundleForClass:[self class]] URLForResource:name
                                                              withExtension:ext
                                                               subdirectory:subdirectory];
    NSAssert(fileURL, @"The file URL should not be nil.");
    return fileURL;
}

- (NSString *)wcl_stringWithContentsOfFileURL:(NSURL *)fileURL
{
    NSError *error;
    NSString *contents = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&error];
    NSString *errorMessage = [NSString stringWithFormat:@"There should not be an NSError. %@", error];
    NSAssert(!error, errorMessage);
    return contents;
}

+ (NSURL *)wcl_URLForSharedTestResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subdirectory
{
    Plugin *plugin = [[PluginsManager sharedInstance] pluginWithName:kSharedTestResourcesPluginName];
    NSURL *resourceURL = [plugin resourceURL];

    NSURL *fileURL = [[[resourceURL URLByAppendingPathComponent:subdirectory]
                   URLByAppendingPathComponent:name]
                  URLByAppendingPathExtension:ext];
    NSAssert(fileURL, @"The file URL should not be nil");
    return fileURL;
}

@end