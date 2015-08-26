//
//  WCLWebViewController+WCLWebViewController_AppleScript.m
//  Web Console
//
//  Created by Roben Kleene on 8/23/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import "WCLWebViewController+AppleScript.h"

#import "WCLAppleScriptPluginWrapper.h"

@implementation WCLWebViewController (AppleScript)

- (WCLAppleScriptPluginWrapper * __nonnull)pluginWrapper
{
    return [[WCLAppleScriptPluginWrapper alloc] initWithPlugin:self.plugin];
}

- (NSScriptObjectSpecifier *)objectSpecifier
{
    NSWindow *containerWindow = [self.delegate windowForWebViewController:self];
    NSScriptClassDescription *containerClassDescription = (NSScriptClassDescription *)[NSScriptClassDescription classDescriptionForClass:[containerWindow class]];

    return [[NSUniqueIDSpecifier alloc] initWithContainerClassDescription:containerClassDescription
                                                       containerSpecifier:[containerWindow objectSpecifier]
                                                                      key:@"views"
                                                                 uniqueID:self.identifier];
}

@end
