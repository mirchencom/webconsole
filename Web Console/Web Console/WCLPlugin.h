//
//  Plugin.h
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCLPlugin : NSObject

/*! Returns a WCLPlugin object initialized to correspond to the specified directory.
 * \param path The path to a directory. This must be a full pathname for a directory; if it contains any symbolic links, they must be resolvable.
 * \returns The WCLPlugin object that corresponds to path, or nil if path does not identify an accessible WCLPlugin directory.
 */
- (id)initWithPath:(NSString *)path;

/*! Returns the receiver's name.
 * \returns The receiver's name.
 */
- (NSString *)name;

/*! Runs the receiver's command.
 * \param arguments An array of NSString objects that supplies the arguments to the receiver's command.
 * \param directoryPath The current directory for the receiver's command.
 */
- (void)runWithArguments:(NSArray *)arguments inDirectoryPath:(NSString *)directoryPath;

/*! Returns the full URL of the receiver’s resource directory.
 * \returns The full URL of the receiver’s resource directory.
 */
- (NSURL *)resourceURL;

/*! Returns the full pathname of the receiver’s resource directory.
 * \returns The full pathname of the receiver’s resource directory.
 */
- (NSString *)resourcePath;

#pragma mark - AppleScript
- (void)handleRunScriptCommand:(NSScriptCommand *)command;
- (void)handleReadFromStandardInputScriptCommand:(NSScriptCommand *)command;
- (NSArray *)orderedWindows;

@end