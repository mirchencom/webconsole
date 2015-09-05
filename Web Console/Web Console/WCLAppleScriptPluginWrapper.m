//
//  WCLAppleScriptPluginWrapper.m
//  Web Console
//
//  Created by Roben Kleene on 2/9/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import "WCLAppleScriptPluginWrapper.h"

#import "Web_Console-Swift.h"
#import "WCLPluginView.h"

@interface WCLAppleScriptPluginWrapper ()
@property (nonatomic, readonly, strong) Plugin *plugin;
@end

@implementation WCLAppleScriptPluginWrapper

- (instancetype)initWithPlugin:(Plugin *)plugin {
    self = [super init];
    if (self) {
        _plugin = plugin;
    }
    return self;
}

- (NSString *)name
{
    return self.plugin.name;
}

- (NSString *)resourcePath
{
    return self.plugin.resourcePath;
}

- (NSString *)resourceURLString
{
    return self.plugin.resourceURL.absoluteString;
}
- (NSArray *)orderedWindows
{
    return [self.plugin orderedWindows];
}

- (id)handleRunScriptCommand:(NSScriptCommand *)command
{
    NSDictionary *argumentsDictionary = [command evaluatedArguments];
    
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
    
    [command suspendExecution];
    [pluginView runPlugin:self.plugin
            withArguments:arguments
          inDirectoryPath:[directoryURL path]
        completionHandler:^(BOOL success)
     {
         [command resumeExecutionWithResult:pluginView];
     }];
    
    return nil;
}

- (NSScriptObjectSpecifier *)objectSpecifier
{
    NSScriptClassDescription *containerClassDescription = (NSScriptClassDescription *)[NSScriptClassDescription classDescriptionForClass:[NSApp class]];
    return [[NSNameSpecifier alloc] initWithContainerClassDescription:containerClassDescription
                                                   containerSpecifier:nil
                                                                  key:@"plugins"
                                                                 name:self.name];
}

@end
