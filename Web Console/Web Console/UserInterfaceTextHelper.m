//
//  UserInterfaceTextHelper.m
//  Web Console
//
//  Created by Roben Kleene on 7/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "UserInterfaceTextHelper.h"

@implementation UserInterfaceTextHelper

+ (NSString *)closeWindowWithTasksInformativeTextForTasks:(NSArray *)tasks
{
    NSMutableString *commands = [NSMutableString stringWithString:@""];
    NSArray *launchPathStrings = [tasks valueForKey:@"launchPath"];
    for (NSString *launchPathString in launchPathStrings) {
        NSString *command = [NSString stringWithFormat:@"%@,", [launchPathString lastPathComponent]];
        commands = [NSMutableString stringWithFormat:@"%@ %@", commands, command];
    }
    [commands deleteCharactersInRange:NSMakeRange([commands length] - 1, 1)];
    return [NSString stringWithFormat:@"Closing this window will terminate the following running commands: %@.",  commands];
    
}

@end