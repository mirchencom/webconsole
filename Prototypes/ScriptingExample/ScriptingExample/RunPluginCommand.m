//
//  RunPluginCommand.m
//  ScriptingExample
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "RunPluginCommand.h"


#define kArgumentsKey @"Arguments"

@implementation RunPluginCommand

- (id)performDefaultImplementation {
    
    NSString *name = [self directParameter];
    
	NSDictionary *argumentsDictionary = [self evaluatedArguments];
    id arguments = [argumentsDictionary objectForKey:kArgumentsKey];
        
    NSLog(@"name = %@, arguments = %@", name, arguments);

    NSLog(@"[arguments class] = %@", [arguments class]);
    return nil;
}

@end
