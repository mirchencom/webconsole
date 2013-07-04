//
//  Plugin.m
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "Plugin.h"

#define kPluginNameKey @"Name"

@interface Plugin ()
@property (nonatomic, strong) NSBundle *bundle;
@end

@implementation Plugin

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _bundle = [NSBundle bundleWithPath:path];

        // Bundle Validation
        if (!_bundle
            || !([self name] > 0)) {
            return nil;
        }
    }
    
    return self;
}

- (NSString *)name
{
    return [self.bundle.infoDictionary objectForKey:kPluginNameKey];
}

- (void)run
{
    NSLog(@"got here run");
}

@end
