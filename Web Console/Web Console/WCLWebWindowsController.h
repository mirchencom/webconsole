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

/*! Returns a shared singleton WebWindowsController object.
 */
+ (id)sharedWebWindowsController;

/*! Returns an added WebWindowController.
 * \return An added WebWindowController.
 */
- (WCLWebWindowController *)addedWebWindowController;

/*! Returns an added WebWindowController for a Plugin.
 * \param plugin The Plugin to set as the returned WebWindowController's plugin.
 * \return A WebWindowController for a Plugin.
 */
- (WCLWebWindowController *)addedWebWindowControllerForPlugin:(WCLPlugin *)plugin;

/*! Removes a WebWindowController.
 */
- (void)removeWebWindowController:(WCLWebWindowController *)webWindowController;

/*! Returns an array of WebWindowController objects.
 * \returns An array of WebWindowController objects.
 */
- (NSArray *)webWindowControllers;

/*! Returns an array of WebWindowController objects for a Plugin.
 * \returns An array of WebWindowController objects for a Plugin.
 */
- (NSArray *)webWindowControllersForPlugin:(WCLPlugin *)plugin;

/*! Returns an array of NSWindow objects for a Plugin.
 * \returns An array of NSWindow objects for a Plugin.
 */
- (NSArray *)windowsForPlugin:(WCLPlugin *)plugin;

/*! Returns an array of NSTask objects.
 * \returns An array of NSTask objects.
 */
- (NSArray *)tasks;

@end