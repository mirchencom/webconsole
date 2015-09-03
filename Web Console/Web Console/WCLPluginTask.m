//
//  WCLPluginTask.m
//  Web Console
//
//  Created by Roben Kleene on 1/11/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import "WCLPluginTask.h"



@implementation WCLPluginTask

+ (void)runTaskWithCommandPath:(NSString *)commandPath
                 withArguments:(NSArray *)arguments
               inDirectoryPath:(NSString *)directoryPath
                      delegate:(id<WCLPluginTaskDelegate>)delegate
             completionHandler:(void (^)(BOOL success))completionHandler
{
    DLog(@"runCommandPath:%@ withArguments:%@ inDirectoryPath:%@", commandPath, arguments, directoryPath);
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = commandPath;
    
    if (arguments) {
        task.arguments = arguments;
    }
    
    if (directoryPath) {
        task.currentDirectoryPath = directoryPath;
    }

    // Standard Output
    task.standardOutput = [NSPipe pipe];
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        DLog(@"[Task] standardOutput %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // Standard Error
    task.standardError = [NSPipe pipe];
    [[task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        DLog(@"[Task] standardError %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    // Standard Input
    [task setStandardInput:[NSPipe pipe]];
    
    // Termination handler
    [task setTerminationHandler:^(NSTask *task) {
        DLog(@"[Task] termination launchPath %@", task.launchPath);
        
        // Standard Input, Output & Error
        [[task.standardOutput fileHandleForReading] setReadabilityHandler:nil];
        [[task.standardError fileHandleForReading] setReadabilityHandler:nil];
        
        if ([delegate respondsToSelector:@selector(pluginTaskDidFinish:)]) {
            [delegate pluginTaskDidFinish:task];
        }
        
        // As per NSTask.h, NSTaskDidTerminateNotification is not posted if a termination handler is set, so post it here.
        [[NSNotificationCenter defaultCenter] postNotificationName:NSTaskDidTerminateNotification object:task];
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        // For some reason an infinite loop results if this isn't dispatched to the main queue.
        // This has to run on the main queue, because it involves coordination with the UI.
        // But even if it's already on the main queue, it still needs to be dispatched, otherwise an infinite loop results.
        if ([delegate respondsToSelector:@selector(pluginTaskWillStart:)]) {
            [delegate pluginTaskWillStart:task];
        }
        
        NSDictionary *environmentDictionary;
        if ([delegate respondsToSelector:@selector(environmentDictionaryForPluginTask:)]) {
            environmentDictionary = [delegate environmentDictionaryForPluginTask:task];
        }
        if (environmentDictionary) {
            [task setEnvironment:environmentDictionary];
        }
        [task launch];
        
        completionHandler(YES);
    });
}

@end
