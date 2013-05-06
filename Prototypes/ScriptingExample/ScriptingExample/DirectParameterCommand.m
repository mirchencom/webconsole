//
//  DirectParameterCommand.m
//  ScriptingExample
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "DirectParameterCommand.h"

@implementation DirectParameterCommand

- (id)performDefaultImplementation {
    NSLog(@"DirectParameterCommand performDefaultImplementation");
	
    /* show the direct parameter */
	NSLog(@"The direct parameter is: '%@'", [self directParameter]);
    
    /* return the quoted direct parameter to show how to return a string from a command */
	return [NSString stringWithFormat:@"'%@'", [self directParameter]];
}

@end
