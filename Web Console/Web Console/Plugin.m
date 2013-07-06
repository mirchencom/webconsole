//
//  Plugin.m
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "Plugin.h"

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
    [task setEnvironment:environmentDictionary];
    
    task.standardOutput = [NSPipe pipe];
    
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [task setTerminationHandler:^(NSTask *task) {
        [[task.standardOutput fileHandleForReading] setReadabilityHandler:nil];
        //        [task.standardError fileHandleForReading].readabilityHandler = nil;
        //        BOOL success = [task terminationStatus] == 0;
        //        completionHandler(success);
    }];
    
    [task launch];
    
}

@end
