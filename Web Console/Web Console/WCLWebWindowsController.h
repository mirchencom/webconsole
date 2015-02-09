//
//  WebWindowsController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCLWebWindowController;
@class Plugin;

@interface WCLWebWindowsController : NSObject
+ (instancetype)sharedWebWindowsController;
- (WCLWebWindowController *)addedWebWindowController;
- (WCLWebWindowController *)addedWebWindowControllerForPlugin:(Plugin *)plugin;
- (void)removeWebWindowController:(WCLWebWindowController *)webWindowController;
- (NSArray *)webWindowControllers;
- (NSArray *)webWindowControllersForPlugin:(Plugin *)plugin;
- (NSArray *)windowsForPlugin:(Plugin *)plugin;
- (NSArray *)tasks;
@end