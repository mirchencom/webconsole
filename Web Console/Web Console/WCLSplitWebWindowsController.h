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

@interface WCLSplitWebWindowsController : NSObject
+ (instancetype)sharedWebWindowsController;
- (WCLSplitWebWindowController *)addedWebWindowController;
- (WCLSplitWebWindowController *)addedWebWindowControllerForPlugin:(Plugin *)plugin;
- (void)removeWebWindowController:(WCLSplitWebWindowController *)webWindowController;
- (NSArray *)webWindowControllers;
- (NSArray *)webWindowControllersForPlugin:(Plugin *)plugin;
- (NSArray *)windowsForPlugin:(Plugin *)plugin;
- (NSArray *)tasks;
@end
