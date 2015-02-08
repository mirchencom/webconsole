//
//  Plugin.h
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCLPlugin : NSObject
@property (nonatomic, assign, getter = isDefaultNewPlugin) BOOL defaultNewPlugin;
#pragma mark Validation
- (BOOL)validateExtensions:(id *)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL)validateName:(id *)ioValue error:(NSError * __autoreleasing *)outError;

/*! Runs the receiver's command.
 * \param arguments An array of NSString objects that supplies the arguments to the receiver's command.
 * \param directoryPath The current directory for the receiver's command.
 */
- (void)runWithArguments:(NSArray *)arguments inDirectoryPath:(NSString *)directoryPath;

#pragma mark - AppleScript
- (void)handleRunScriptCommand:(NSScriptCommand *)command;
- (void)handleReadFromStandardInputScriptCommand:(NSScriptCommand *)command;
- (NSArray *)orderedWindows;
@end