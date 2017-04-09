//
//  WCLWebViewController+WCLWebViewController_AppleScript.h
//  Web Console
//
//  Created by Roben Kleene on 8/23/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import "WCLWebViewController.h"

@class WCLAppleScriptPluginWrapper;

NS_ASSUME_NONNULL_BEGIN
@interface WCLWebViewController (AppleScript)
@property (nonatomic, strong, readonly) WCLAppleScriptPluginWrapper *pluginWrapper;
@property (nonatomic, strong, readonly) NSString *pluginName;
@end
NS_ASSUME_NONNULL_END
