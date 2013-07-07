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

- (void)runWithArguments:(NSArray *)arguments inDirectoryPath:(NSString *)directoryPath
{
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

    NSMutableDictionary *environmentDictionary = [[NSMutableDictionary alloc] init];
    environmentDictionary[kEnvironmentVariablePathKey] = kEnvironmentVariablePathValue;

    WebWindowController *webWindowController = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];

    NSLog(@"Starting task webWindowController.window.windowNumber = %ld", (long)webWindowController.window.windowNumber);

    environmentDictionary[kEnvironmentVariableWindowIDKey] = [NSNumber numberWithInteger:webWindowController.window.windowNumber];
    
    [task setEnvironment:environmentDictionary];
    
    task.standardOutput = [NSPipe pipe];
    
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [task setTerminationHandler:^(NSTask *task) {
        [[task.standardOutput fileHandleForReading] setReadabilityHandler:nil];
        
        
        NSLog(@"Ending task webWindowController.window.windowNumber = %ld", (long)webWindowController.window.windowNumber);
        if (![webWindowController.window isVisible]) {
            // Remove the WebWindowController if the window was never shown
            NSLog(@"Removing a window");
            
            [[WebWindowsController sharedWebWindowsController] removeWebWindowController:webWindowController];
        }
        
        //        [task.standardError fileHandleForReading].readabilityHandler = nil;
        //        BOOL success = [task terminationStatus] == 0;
        //        completionHandler(success);
    }];
    
    [task launch];
    
}

@end
