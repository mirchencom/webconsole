//
//  NSWindow+AppleScript.h
//  Web Console
//
//  Created by Roben Kleene on 8/23/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "WCLPluginView.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSWindow (AppleScript) <WCLPluginView>
- (NSArray<id <WCLPluginView>> *)splits;
@end
NS_ASSUME_NONNULL_END
