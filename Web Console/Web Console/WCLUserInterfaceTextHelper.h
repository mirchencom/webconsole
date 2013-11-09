//
//  UserInterfaceTextHelper.h
//  Web Console
//
//  Created by Roben Kleene on 7/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLaunchPathKey @"launchPath"

@interface WCLUserInterfaceTextHelper : NSObject

/*! Returns informative text for closing windows running commands.
 * \param commandPaths An array of command paths.
 * \returns The informative text.
 */
+ (NSString *)informativeTextForCloseWindowForCommands:(NSArray *)commandPaths;

@end
