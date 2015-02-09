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
#pragma mark - AppleScript
- (void)handleRunScriptCommand:(NSScriptCommand *)command;
- (void)handleReadFromStandardInputScriptCommand:(NSScriptCommand *)command;
- (void)readFromStandardInput:(NSString *)text;
@end