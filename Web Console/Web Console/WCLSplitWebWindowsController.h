//
//  WebWindowsController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCLSplitWebWindowController;
@class Plugin;

NS_ASSUME_NONNULL_BEGIN
@interface WCLSplitWebWindowsController : NSObject
+ (instancetype)sharedSplitWebWindowsController;
- (WCLSplitWebWindowController *)addedSplitWebWindowController;
- (NSArray *)splitWebWindowControllers;
- (NSArray *)splitWebWindowControllersForPlugin:(Plugin *)plugin;
- (NSArray *)windowsForPlugin:(Plugin *)plugin;
- (NSArray *)tasks;
@end
NS_ASSUME_NONNULL_END
