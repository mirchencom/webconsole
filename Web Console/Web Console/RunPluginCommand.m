//
//  RunPluginCommand.m
//  ScriptingExample
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "RunPluginCommand.h"

#import "PluginManager.h"

@implementation RunPluginCommand

- (id)performDefaultImplementation {
    
    NSString *name = [self directParameter];
    
	NSDictionary *argumentsDictionary = [self evaluatedArguments];
    NSArray *arguments = [argumentsDictionary objectForKey:kArgumentsKey];

    NSURL *directoryURL = [argumentsDictionary objectForKey:kDirectoryKey];
    
    NSLog(@"name = %@, arguments = %@, directory = %@", name, arguments, directoryURL);

    NSLog(@"[directory class] = %@", [directoryURL class]);

//    Plugin *plugin = [[PluginManager sharedPluginManager] pluginWithName:@"Example"];
//    
//    [plugin run];

    return nil;
}

@end
