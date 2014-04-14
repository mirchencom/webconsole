//
//  WCLPluginTask.m
//  Web Console
//
//  Created by Roben Kleene on 1/11/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import "WCLPluginTask.h"

#import "WCLPluginManager.h"

@interface WCLPluginTask ()
+ (NSDictionary *)environmentDictionaryWithWindowNumber:(NSNumber *)windowNumber;
@end

@implementation WCLPluginTask

+ (void)runTask:(NSTask *)task delegate:(id<WCLPluginTaskDelegate>)delegate
{
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
        
        [delegate pluginTaskDidFinish:task];
        
        // As per NSTask.h, NSTaskDidTerminateNotification is not posted if a termination handler is set, so post it here.
        [[NSNotificationCenter defaultCenter] postNotificationName:NSTaskDidTerminateNotification object:task];
    }];
    

    [delegate pluginTaskWillStart:task];

    dispatch_async(dispatch_get_main_queue(), ^{

        // Setting the windowNumber in the enviornmentDictionary must happen after showing the window
        NSDictionary *environmentDictionary = [self environmentDictionaryWithWindowNumber:[delegate pluginTaskWindowNumber]];
        
        [task setEnvironment:environmentDictionary];
        [task launch];
    });
}

+ (NSDictionary *)environmentDictionaryWithWindowNumber:(NSNumber *)windowNumber
{
    NSMutableDictionary *environmentDictionary = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:kEnvironmentDictionaryKey] mutableCopy];
    
    environmentDictionary[kEnvironmentVariableSharedResourcePathKey] = [[WCLPluginManager sharedPluginManager] sharedResourcePath];
    environmentDictionary[kEnvironmentVariableSharedResourceURLKey] = [[[WCLPluginManager sharedPluginManager] sharedResourceURL] absoluteString];
    environmentDictionary[kEnvironmentVariableWindowIDKey] = windowNumber;

    return environmentDictionary;
}

@end
