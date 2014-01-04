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

#define kPluginNameKey @"Name"
#define kPluginCommandKey @"Command"

@interface WCLPlugin ()
@property (nonatomic, strong) NSBundle *bundle;
- (NSString *)commandPath;
- (NSString *)command;
- (NSString *)resourcePath;
- (void)runCommandPath:(NSString *)commandPath
         withArguments:(NSArray *)arguments
       inDirectoryPath:(NSString *)directoryPath;
- (void)readFromStandardInput:(NSString *)text;
@end

@interface WCLWebWindowController (Plugin)
@property (nonatomic, strong) NSMutableArray *mutableTasks;
@end

@implementation WCLPlugin

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _bundle = [NSBundle bundleWithPath:path];
        
        // Bundle Validation
        if (!_bundle
            || !([self name] > 0)) {
            return nil;
        }
    }
    
    return self;
}

#pragma mark - Dictionary


- (NSString *)name
{
    return [self.bundle.infoDictionary objectForKey:kPluginNameKey];
}

- (NSString *)command
{
    return [self.bundle.infoDictionary objectForKey:kPluginCommandKey];
}

- (NSString *)resourcePath {
    return [self.bundle resourcePath];
}

- (NSURL *)resourceURL
{
    return [self.bundle resourceURL];
}

- (NSString *)resourceURLString
{
    return [[self.bundle resourceURL] absoluteString];
}

- (NSString *)commandPath
{
    NSString *command = [self command];
    
    if ([command isAbsolutePath]) return command;

    return [[self resourcePath] stringByAppendingPathComponent:command];
}


#pragma mark - AppleScript

- (NSScriptObjectSpecifier *)objectSpecifier {    
    NSScriptClassDescription *containerClassDescription = (NSScriptClassDescription *)[NSScriptClassDescription classDescriptionForClass:[NSApp class]];
	return [[NSNameSpecifier alloc] initWithContainerClassDescription:containerClassDescription
                                                   containerSpecifier:nil
                                                                  key:@"plugins"
                                                                 name:[self name]];
}

- (NSArray *)orderedWindows {
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
    DLog(@"runCommandPath:%@ withArguments:%@ inDirectoryPath:%@", commandPath, arguments, directoryPath);
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:commandPath];
    if (directoryPath) {
        [task setCurrentDirectoryPath:directoryPath];
    }
    if (arguments) {
        [task setArguments:arguments];
    }   
    
    // Environment Dictionary
    NSMutableDictionary *environmentDictionary = [[NSMutableDictionary alloc] init];
    environmentDictionary[kEnvironmentVariablePathKey] = kEnvironmentVariablePathValue;
    
    // Web Window Controller
    WCLWebWindowController *webWindowController = [[WCLWebWindowsController sharedWebWindowsController] addedWebWindowControllerForPlugin:self];
    [webWindowController.mutableTasks addObject:task];

    // Standard Output
    task.standardOutput = [NSPipe pipe];
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // Standard Error
    task.standardError = [NSPipe pipe];
    [[task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        DLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // Standard Input
    [task setStandardInput:[NSPipe pipe]];
    
    // Termination handler
    [task setTerminationHandler:^(NSTask *task) {
        DLog(@"Terminate %@", commandPath);
        
        // Standard Input, Output & Error
        [[task.standardOutput fileHandleForReading] setReadabilityHandler:nil];
        [[task.standardError fileHandleForReading] setReadabilityHandler:nil];
        
        [webWindowController.mutableTasks removeObject:task];
        
        // As per NSTask.h, NSTaskDidTerminateNotification is not posted if a termination handler is set, so post it here.
        [[NSNotificationCenter defaultCenter] postNotificationName:NSTaskDidTerminateNotification object:task];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [webWindowController showWindow:self];

        // Setting the windowNumber in the enviornmentDictionary must happen after showing the window
        environmentDictionary[kEnvironmentVariableWindowIDKey] = [NSNumber numberWithInteger:webWindowController.window.windowNumber];
        [task setEnvironment:environmentDictionary];
        [task launch];
    });
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
    DLog(@"%@ readFromStandardInput: %@", self.name, text);
    
    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:self];
    
    if (![webWindowControllers count]) return;
    
    WCLWebWindowController *webWindowController = webWindowControllers[0];
    
    if (![webWindowController hasTasks]) return;
    
    NSTask *task = webWindowController.tasks[0];
    
    NSPipe *pipe = (NSPipe *)task.standardInput;
    
    [pipe.fileHandleForWriting writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
