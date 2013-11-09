//
//  WebWindowsController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCLWebWindowController;
@class WCLPlugin;

@interface WCLWebWindowsController : NSObject

/*! Returns a shared singleton WCLWebWindowsController object.
 */
+ (id)sharedWebWindowsController;

/*! Returns an added WCLWebWindowController.
 * \return An added WCLWebWindowController.
 */
- (WCLWebWindowController *)addedWebWindowController;

/*! Returns an added WebWindowController for a Plugin.
 * \param plugin The WCLPlugin to set as the returned WebWindowController's plugin.
 * \return A WebWindowController for a Plugin.
 */
- (WCLWebWindowController *)addedWebWindowControllerForPlugin:(WCLPlugin *)plugin;

/*! Removes a WCLWebWindowController.
 */
- (void)removeWebWindowController:(WCLWebWindowController *)webWindowController;

/*! Returns an array of WCLWebWindowController objects.
 * \returns An array of WCLWebWindowController objects.
 */
- (NSArray *)webWindowControllers;

/*! Returns an array of WCLWebWindowController objects for a WCLPlugin.
 * \returns An array of WCLWebWindowController objects for a WCLPlugin.
 */
- (NSArray *)webWindowControllersForPlugin:(WCLPlugin *)plugin;

/*! Returns an array of NSWindow objects for a WCLPlugin.
 * \returns An array of NSWindow objects for a WCLPlugin.
 */
- (NSArray *)windowsForPlugin:(WCLPlugin *)plugin;

/*! Returns an array of NSTask objects.
 * \returns An array of NSTask objects.
 */
- (NSArray *)tasks;

@end