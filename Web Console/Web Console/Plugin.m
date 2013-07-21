//
//  Plugin.m
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "Plugin.h"

#import "WebWindowsController.h"
#import "WebWindowController.h"

#import "NSApplication+AppleScript.h"

#define kPluginNameKey @"Name"
#define kPluginCommandKey @"Command"

@interface Plugin ()
@property (nonatomic, strong) NSBundle *bundle;
- (NSString *)commandPath;
- (NSString *)command;
- (NSString *)resourcePath;
@end

@implementation Plugin

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
    return [[WebWindowsController sharedWebWindowsController] windowsForPlugin:self];
}

#pragma mark - Task

- (void)runWithArguments:(NSArray *)arguments inDirectoryPath:(NSString *)directoryPath
{

    // Configuration
    NSString *commandPath = [self commandPath];
    
    NSLog(@"arguments = %@", arguments);
    NSLog(@"directoryPath = %@", directoryPath);
    NSLog(@"commandPath = %@", commandPath);
    
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
    environmentDictionary[kEnvironmentVariablePluginDirectoryKey] = [self resourcePath];
    
    // Web Window Controller
    WebWindowController *webWindowController = [[WebWindowsController sharedWebWindowsController] addedWebWindowControllerForPlugin:self];
    environmentDictionary[kEnvironmentVariableWindowIDKey] = [NSNumber numberWithInteger:webWindowController.window.windowNumber];
    [webWindowController.tasks addObject:task];
    [task setEnvironment:environmentDictionary];
    
    // Standard Output
    task.standardOutput = [NSPipe pipe];
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // Standard Error
    task.standardError = [NSPipe pipe];
    [[task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // Standard Input
    [task setStandardInput:[NSPipe pipe]];
    
    // Termination handler
    [task setTerminationHandler:^(NSTask *task) {
        NSLog(@"Ending task webWindowController.window.windowNumber = %ld", (long)webWindowController.window.windowNumber);
        
        // Standard Input, Output & Error
        [[task.standardOutput fileHandleForReading] setReadabilityHandler:nil];
        [[task.standardError fileHandleForReading] setReadabilityHandler:nil];
        
        // Web Window Controller
        if (![webWindowController.window isVisible]) {
            // Remove the WebWindowController if the window was never shown
            NSLog(@"Removing a window");
            [[WebWindowsController sharedWebWindowsController] removeWebWindowController:webWindowController];
        }
        [webWindowController.tasks removeObject:task];
        
        // As per NSTask.h, NSTaskDidTerminateNotification is not posted if a termination handler is set, so post it here.
        [[NSNotificationCenter defaultCenter] postNotificationName:NSTaskDidTerminateNotification object:task];
    }];
    
    NSLog(@"Starting task webWindowController.window.windowNumber = %ld", (long)webWindowController.window.windowNumber);
    [task launch];
}

#pragma mark - AppleScript

- (void)run:(NSScriptCommand *)command
{
	NSDictionary *argumentsDictionary = [command evaluatedArguments];
    NSArray *arguments = [argumentsDictionary objectForKey:kArgumentsKey];
    
    NSURL *directoryURL = [argumentsDictionary objectForKey:kDirectoryKey];
    
    // TODO: Return an error if the plugin doesn't exist
    // TODO: Return an error if the directory doesn't exist
    
    [self runWithArguments:arguments inDirectoryPath:[directoryURL path]];
}

- (void)readFromStandardInput:(NSScriptCommand *)command
{
	NSDictionary *argumentsDictionary = [command evaluatedArguments];
    NSString *text = [argumentsDictionary objectForKey:kTextKey];

NSLog(@"text = %@", text);
    
    
//	NSDictionary *argumentsDictionary = [command evaluatedArguments];

    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:self];
    
    if (![webWindowControllers count]) return;
    
    WebWindowController *webWindowController = webWindowControllers[0];

    if (![webWindowController.tasks count]) return;
    
    NSTask *task = webWindowController.tasks[0];

    NSPipe *pipe = (NSPipe *)task.standardInput;


// TODO: Make it work
NSLog(@"pipe.fileHandleForWriting = %@", pipe.fileHandleForWriting);
NSLog(@"text ready to write = %@", text);
    [pipe.fileHandleForWriting writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];

//    [self performSelector:@selector(endIt:) withObject:nil afterDelay:2.0];
}

//- (void)endIt:(id)sender {
//    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:self];
//    
//    if (![webWindowControllers count]) return;
//    
//    WebWindowController *webWindowController = webWindowControllers[0];
//    
//    if (![webWindowController.tasks count]) return;
//    
//    NSTask *task = webWindowController.tasks[0];
//
//    [task interrupt];
//}


@end
