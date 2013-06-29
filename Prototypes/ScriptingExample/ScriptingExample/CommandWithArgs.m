//
//  CommandWithArgs.m
//  ScriptingExample
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "CommandWithArgs.h"

@implementation CommandWithArgs

- (id)performDefaultImplementation {
    
	NSDictionary * theArguments = [self evaluatedArguments];
	NSString *theResult;
	
	NSLog(@"CommandWithArgs performDefaultImplementation");
	
    /* report the parameters */
	NSLog(@"The direct parameter is: '%@'", [self directParameter]);
	NSLog(@"The other parameters are: '%@'", theArguments);
    
    /* return the quoted direct parameter to show how to return a string from a command
     Here, if the optional ProseText parameter has been provided, we return that value in
     quotes, otherwise we return the direct parameter in quotes. */
	if ([theArguments objectForKey:@"ProseText"]) {
		theResult = [NSString stringWithFormat:@"'%@'", [theArguments objectForKey:@"ProseText"]];
	} else {
		theResult = [NSString stringWithFormat:@"'%@'", [self directParameter]];
	}
	

    NSLog(@"[NSScriptCommand currentCommand] = %@", [NSScriptCommand currentCommand]);
    NSLog(@"[self] = %@", self);
    
    [self suspendExecution];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resumeExecutionWithResult:theResult];
    });

	
    return nil;
}

@end
