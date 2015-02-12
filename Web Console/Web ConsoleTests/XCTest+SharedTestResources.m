//
//  SenTestCase+BundleResources.m
//  RubyUnitTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "XCTest+SharedTestResources.h"
#import "XCTest+BundleResources.h"
#import "Web_ConsoleTestsConstants.h"
#import "WebConsoleConstants.h"

@implementation XCTestCase (SharedTestResources)

+ (NSString *)wcl_stringWithContentsOfSharedTestResource:(NSString *)filename
                                           withExtension:(NSString *)extension
                                            subdirectory:(NSString *)subdirectory
{
    NSURL *fileURL = [[self class] wcl_URLForSharedTestResource:filename
                                                  withExtension:extension
                                                   subdirectory:subdirectory];
    return [self wcl_stringWithContentsOfFileURL:fileURL];
}

+ (NSURL *)wcl_sharedTestResourcesURL
{
    static dispatch_once_t pred;
    static NSURL *sharedTestResourcesPluginResourcesURL;
    dispatch_once(&pred, ^{
        NSURL *builtInPluginsURL = [[NSBundle mainBundle] builtInPlugInsURL];
        NSString *sharedTestResourcesPluginDirectoryName = [NSString stringWithFormat:@"%@.%@", kSharedTestResourcesPluginName, kPlugInExtension];
        NSURL *sharedTestResourcesPluginURL = [builtInPluginsURL URLByAppendingPathComponent:sharedTestResourcesPluginDirectoryName];
        sharedTestResourcesPluginResourcesURL = [sharedTestResourcesPluginURL URLByAppendingPathComponent:kPluginResourcesPathComponent];
    });
    return sharedTestResourcesPluginResourcesURL;
}

+ (NSURL *)wcl_URLForSharedTestResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subdirectory
{
    NSURL *sharedTestResourcesPluginResourcesURL = [self wcl_sharedTestResourcesURL];
    NSURL *fileURL = [[[sharedTestResourcesPluginResourcesURL URLByAppendingPathComponent:subdirectory]
                       URLByAppendingPathComponent:name]
                      URLByAppendingPathExtension:ext];
    NSAssert(fileURL, @"The file URL should not be nil");
    return fileURL;
}

@end