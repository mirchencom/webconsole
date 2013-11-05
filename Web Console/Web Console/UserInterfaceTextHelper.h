//
//  UserInterfaceTextHelper.h
//  Web Console
//
//  Created by Roben Kleene on 7/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCommandsKey @"launchPath"

@interface UserInterfaceTextHelper : NSObject
+ (NSString *)informativeTextForCloseWindowForCommands:(NSArray *)commandPaths;
@end
