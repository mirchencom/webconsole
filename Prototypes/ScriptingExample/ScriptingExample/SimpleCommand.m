//
//  SimpleCommand.m
//  ScriptingExample
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "SimpleCommand.h"

@implementation SimpleCommand

- (id)performDefaultImplementation {
    NSLog(@"SimpleCommand performDefaultImplementation");
	
    /* return 7 to show how to return a number from a command */
	return [NSNumber numberWithInt:7];
}

@end
