//
//  UserInterfaceTextHelper.m
//  Web Console
//
//  Created by Roben Kleene on 7/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "UserInterfaceTextHelper.h"

@implementation UserInterfaceTextHelper

+ (NSString *)informativeTextForCloseWindowForCommands:(NSArray *)commandPaths
{
    if (![commandPaths count]) return nil;
    
    NSMutableString *commandsText = [NSMutableString stringWithString:@""];
    for (NSString *commandPath in commandPaths) {
        NSString *commandText = [NSString stringWithFormat:@"%@,", [commandPath lastPathComponent]];
        commandsText = [NSMutableString stringWithFormat:@"%@ %@", commandsText, commandText];
    }
    [commandsText deleteCharactersInRange:NSMakeRange([commandsText length] - 1, 1)];
    return [NSString stringWithFormat:@"Closing this window will terminate the following running commands:%@.", commandsText];
}

@end