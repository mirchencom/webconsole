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

#define kPluginNameKey @"Name"
#define kPluginCommandKey @"Command"

@interface Plugin ()
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSMutableArray *webWindowControllers;
- (NSString *)commandPath;
- (NSString *)command;
- (NSString *)resourcePath;
- (WebWindowController *)addedWebWindowController;
- (void)removeWebWindowController:(WebWindowController *)webWindowController;
@end

@implementation Plugin

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _bundle = [NSBundle bundleWithPath:path];
        _webWindowControllers = [NSMutableArray array];
        
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

#pragma mark - WebWindowController


- (WebWindowController *)addedWebWindowController
{
    WebWindowController *webWindowController = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];

    [self.webWindowControllers addObject:webWindowController];

    return webWindowController;
}

- (void)removeWebWindowController:(WebWindowController *)webWindowController
{
    [self.webWindowControllers removeObject:webWindowController];
    [[WebWindowsController sharedWebWindowsController] removeWebWindowController:webWindowController];
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
    WebWindowController *webWindowController = [self addedWebWindowController];
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
    task.standardInput = [NSPipe pipe];
    
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
            [self removeWebWindowController:webWindowController];
        }
        [webWindowController.tasks removeObject:task];        
    }];
    
    NSLog(@"Starting task webWindowController.window.windowNumber = %ld", (long)webWindowController.window.windowNumber);
    [task launch];
}

- (void)readFromStandardInput:(NSString *)text {

    if (![self.webWindowControllers count]) return;
    
    WebWindowController *webWindowController = self.webWindowControllers[0];

    if (![webWindowController.tasks count]) return;
    
    NSTask *task = webWindowController.tasks[0];

    NSPipe *pipe = (NSPipe *)task.standardInput;

#warning Make it work
NSLog(@"pipe.fileHandleForWriting = %@", pipe.fileHandleForWriting);
NSLog(@"text = %@", text);
    //    [pipe.fileHandleForWriting writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
