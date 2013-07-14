//
//  ReadFromStandardInputCommand.m
//  Web Console
//
//  Created by Roben Kleene on 7/11/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "ReadFromStandardInputCommand.h"

#import "PluginManager.h"
#import "Plugin.h"

@implementation ReadFromStandardInputCommand

- (id)performDefaultImplementation {
    
    NSString *text = [self directParameter];
    
	NSDictionary *argumentsDictionary = [self evaluatedArguments];
    NSString *name = [argumentsDictionary objectForKey:kPluginKey];

    Plugin *plugin = [[PluginManager sharedPluginManager] pluginWithName:name];

    [plugin readFromStandardInput:text];
    
    return nil;
}

@end
