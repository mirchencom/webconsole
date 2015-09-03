//
//  WCLRunPluginCommand.m
//  Web Console
//
//  Created by Roben Kleene on 9/2/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import "WCLRunPluginCommand.h"

#import "Web_Console-Swift.h"

@implementation WCLRunPluginCommand

- (id)performDefaultImplementation {
    
    Plugin *plugin = [self directParameter];
    if (!plugin) {
        return nil;
    }
    
    NSDictionary *argumentsDictionary = [self evaluatedArguments];
    
    // Get the pluginView or make a new window if no target is specified
    id<WCLPluginView> pluginView = [argumentsDictionary objectForKey:kAppleScriptTargetKey];
    if (!pluginView) {
        WCLSplitWebWindowController *splitWebWindowController = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] addedSplitWebWindowController];
        pluginView = splitWebWindowController.window;
    }
    
    NSArray *arguments = [argumentsDictionary objectForKey:kArgumentsKey];
    NSURL *directoryURL = [argumentsDictionary objectForKey:kDirectoryKey];
        
    // TODO: Return an error if the plugin doesn't exist
    // TODO: Return an error if the directory doesn't exist
    
    [self suspendExecution];
    [pluginView runPlugin:plugin
            withArguments:arguments
          inDirectoryPath:[directoryURL path]
        completionHandler:^(BOOL success)
    {
        [self resumeExecutionWithResult:pluginView];
    }];
    
    return nil;
}

@end
