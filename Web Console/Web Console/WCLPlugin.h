//
//  Plugin.h
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCLPlugin : NSObject

/*! Returns a Plugin object initialized to correspond to the specified directory.
 * \param path The path to a directory. This must be a full pathname for a directory; if it contains any symbolic links, they must be resolvable.
 * \returns The Plugin object that corresponds to path, or nil if path does not identify an accessible Plugin directory.
 */
- (id)initWithPath:(NSString *)path;

/*! Returns the name of the Plugin.
 * \returns The name of the Plugin.
 */
- (NSString *)name;

/*! Runs the receiver's command.
 * \param arguments An array of NSString objects that supplies the arguments to the receiver's command.
 * \param directoryPath The current directory for the receiver's command.
 */
- (void)runWithArguments:(NSArray *)arguments inDirectoryPath:(NSString *)directoryPath;

#pragma mark - AppleScript
- (void)run:(NSScriptCommand *)command;
- (void)readFromStandardInput:(NSScriptCommand *)command;
- (NSArray *)orderedWindows;

@end