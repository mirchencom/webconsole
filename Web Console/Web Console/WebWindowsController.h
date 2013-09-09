//
//  WebWindowsController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebWindowController;
@class Plugin;

@interface WebWindowsController : NSObject

+ (id)sharedWebWindowsController;
- (WebWindowController *)addedWebWindowController;
- (WebWindowController *)addedWebWindowControllerForPlugin:(Plugin *)plugin;
- (void)removeWebWindowController:(WebWindowController *)webWindowController;
- (NSArray *)webWindowControllers;
- (NSArray *)webWindowControllersForPlugin:(Plugin *)plugin;
- (NSArray *)windowsForPlugin:(Plugin *)plugin;
- (NSArray *)tasks;
@end