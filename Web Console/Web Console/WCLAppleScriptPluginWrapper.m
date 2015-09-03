//
//  WCLAppleScriptPluginWrapper.m
//  Web Console
//
//  Created by Roben Kleene on 2/9/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import "WCLAppleScriptPluginWrapper.h"

#import "Web_Console-Swift.h"
#import "WCLPluginView.h"

@interface WCLAppleScriptPluginWrapper ()
@property (nonatomic, readonly, strong) Plugin *plugin;
@end

@implementation WCLAppleScriptPluginWrapper

- (instancetype)initWithPlugin:(Plugin *)plugin {
    self = [super init];
    if (self) {
        _plugin = plugin;
    }
    return self;
}

- (NSString *)name
{
    return self.plugin.name;
}

- (NSString *)resourcePath
{
    return self.plugin.resourcePath;
}

- (NSString *)resourceURLString
{
    return self.plugin.resourceURL.absoluteString;
}
- (NSArray *)orderedWindows
{
    return [self.plugin orderedWindows];
}

- (NSScriptObjectSpecifier *)objectSpecifier
{
    NSScriptClassDescription *containerClassDescription = (NSScriptClassDescription *)[NSScriptClassDescription classDescriptionForClass:[NSApp class]];
    return [[NSNameSpecifier alloc] initWithContainerClassDescription:containerClassDescription
                                                   containerSpecifier:nil
                                                                  key:@"plugins"
                                                                 name:self.name];
}

@end
