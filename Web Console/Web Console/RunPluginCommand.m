//
//  RunPluginCommand.m
//  ScriptingExample
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "RunPluginCommand.h"

#import "PluginManager.h"
#import "Plugin.h"

@implementation RunPluginCommand

- (id)performDefaultImplementation {
    
    NSString *name = [self directParameter];
    
	NSDictionary *argumentsDictionary = [self evaluatedArguments];
    NSArray *arguments = [argumentsDictionary objectForKey:kArgumentsKey];

    NSURL *directoryURL = [argumentsDictionary objectForKey:kDirectoryKey];

    Plugin *plugin = [[PluginManager sharedPluginManager] pluginWithName:name];

#warning Return an error if the plugin doesn't exist
#warning Return an error if the directory doesn't exist
    
    [plugin runWithArguments:arguments inDirectoryPath:[directoryURL path]];

    return nil;
}

@end
