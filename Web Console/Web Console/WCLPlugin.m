//
//  Plugin.m
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLPlugin.h"

#import "WCLWebWindowsController.h"
#import "WCLWebWindowController.h"

#import "NSApplication+AppleScript.h"

#import "WCLPluginTask.h"

#import "WCLPlugin+Validation.h"
#import "Web_Console-Swift.h"

@implementation WCLPlugin

@synthesize defaultNewPlugin = _defaultNewPlugin;

- (void)setDefaultNewPlugin:(BOOL)defaultNewPlugin
{
#warning It's problematic that using this setter without going through the plugin manager, will set the flag to true without it actually being the default new plugin
    
    if (_defaultNewPlugin != defaultNewPlugin) {
        _defaultNewPlugin = defaultNewPlugin;
    }
}

- (BOOL)isDefaultNewPlugin
{
    BOOL isDefaultNewPlugin = (self.pluginsManager.defaultNewPlugin == self);
    
    if (_defaultNewPlugin != isDefaultNewPlugin) {
        _defaultNewPlugin = isDefaultNewPlugin;
    }
    
    return _defaultNewPlugin;
}

#pragma mark Validation

- (BOOL)validateExtensions:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    NSArray *extensions;
    if ([*ioValue isKindOfClass:[NSArray class]]) {
        extensions = *ioValue;
    }
    
    BOOL valid = [self extensionsAreValid:extensions];
    if (!valid && outError) {
        NSString *errorMessage = @"The file extensions must be unique, and can only contain alphanumeric characters.";
        NSString *errorString = NSLocalizedString(errorMessage, @"Invalid file extensions error.");
        
        NSDictionary *userInfoDict = @{NSLocalizedDescriptionKey: errorString};
        *outError = [[NSError alloc] initWithDomain:kErrorDomain
                                               code:kErrorCodeInvalidPlugin
                                           userInfo:userInfoDict];
    }
    
    return valid;
}

- (BOOL)validateName:(id *)ioValue error:(NSError * __autoreleasing *)outError
{
    NSString *name;
    if ([*ioValue isKindOfClass:[NSString class]]) {
        name = *ioValue;
    }
    
    BOOL valid = [self nameIsValid:name];
    if (!valid && outError) {
        NSString *errorMessage = @"The plugin name must be unique, and can only contain alphanumeric characters, spaces, hyphens and underscores.";
        NSString *errorString = NSLocalizedString(errorMessage, @"Invalid plugin name error.");
        
        NSDictionary *userInfoDict = @{NSLocalizedDescriptionKey: errorString};
        *outError = [[NSError alloc] initWithDomain:kErrorDomain
                                               code:kErrorCodeInvalidPlugin
                                           userInfo:userInfoDict];
    }
    
    return valid;
}

#pragma mark - AppleScript

- (NSScriptObjectSpecifier *)objectSpecifier
{
    NSScriptClassDescription *containerClassDescription = (NSScriptClassDescription *)[NSScriptClassDescription classDescriptionForClass:[NSApp class]];
	return [[NSNameSpecifier alloc] initWithContainerClassDescription:containerClassDescription
                                                   containerSpecifier:nil
                                                                  key:@"plugins"
                                                                 name:[self name]];
}

- (NSArray *)orderedWindows
{
    return [[WCLWebWindowsController sharedWebWindowsController] windowsForPlugin:self];
}


#pragma mark - Task

- (void)runWithArguments:(NSArray *)arguments inDirectoryPath:(NSString *)directoryPath
{
    [self runCommandPath:[self commandPath]
           withArguments:arguments
         inDirectoryPath:directoryPath];
}

- (void)runCommandPath:(NSString *)commandPath
         withArguments:(NSArray *)arguments
       inDirectoryPath:(NSString *)directoryPath
{
    DLog(@"[Task] runCommandPath:%@ withArguments:%@ inDirectoryPath:%@", commandPath, arguments, directoryPath);
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:commandPath];
    if (directoryPath) {
        [task setCurrentDirectoryPath:directoryPath];
    }
    if (arguments) {
        [task setArguments:arguments];
    }   
    
    WCLWebWindowController *webWindowController = [[WCLWebWindowsController sharedWebWindowsController] addedWebWindowControllerForPlugin:self];
    [WCLPluginTask runTask:task delegate:webWindowController];
}


#pragma mark - AppleScript

- (void)handleRunScriptCommand:(NSScriptCommand *)command
{
	NSDictionary *argumentsDictionary = [command evaluatedArguments];
    NSArray *arguments = [argumentsDictionary objectForKey:kArgumentsKey];
    
    NSURL *directoryURL = [argumentsDictionary objectForKey:kDirectoryKey];
    
    // TODO: Return an error if the plugin doesn't exist
    // TODO: Return an error if the directory doesn't exist
    
    [self runWithArguments:arguments inDirectoryPath:[directoryURL path]];
}

- (void)handleReadFromStandardInputScriptCommand:(NSScriptCommand *)command
{
	NSDictionary *argumentsDictionary = [command evaluatedArguments];
    NSString *text = [argumentsDictionary objectForKey:kTextKey];
    [self readFromStandardInput:text];
}

- (void)readFromStandardInput:(NSString *)text
{
    DLog(@"[AppleScript] %@ readFromStandardInput: %@", self.name, text);
    
    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:self];
    
    if (![webWindowControllers count]) return;
    
    WCLWebWindowController *webWindowController = webWindowControllers[0];
    
    if (![webWindowController hasTasks]) return;
    
    NSTask *task = webWindowController.tasks[0];
    
    NSPipe *pipe = (NSPipe *)task.standardInput;
    
    [pipe.fileHandleForWriting writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
