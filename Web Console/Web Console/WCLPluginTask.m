//
//  WCLPluginTask.m
//  Web Console
//
//  Created by Roben Kleene on 1/11/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import "WCLPluginTask.h"
#import "Web_Console-Swift.h"

@implementation WCLPluginTask

+ (nonnull NSTask *)runTaskWithCommandPath:(NSString *)commandPath
                 withArguments:(NSArray *)arguments
               inDirectoryPath:(NSString *)directoryPath
                      delegate:(id<WCLPluginTaskDelegate>)delegate
             completionHandler:(void (^)(BOOL success))completionHandler
{
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = commandPath;
    
    if (arguments) {
        task.arguments = arguments;
    }
    
    if (directoryPath) {
        // TODO: Add test that the directory path is valid, log a message if debug is on and it's not valid
        // Also return and do nothing in this case, remember to fire the completion handler
        task.currentDirectoryPath = directoryPath;
    }

    // Standard Output
    task.standardOutput = [NSPipe pipe];
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self processStandardOutput:text task:task delegate:delegate];
    }];
    
    // Standard Error
    task.standardError = [NSPipe pipe];
    [[task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self processStandardError:text task:task delegate:delegate];
    }];
    
    // Standard Input
    [task setStandardInput:[NSPipe pipe]];
    
    // Termination handler
    [task setTerminationHandler:^(NSTask *task) {

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
        // An infinite loop results if this isn't dispatched to the main queue.
        // Even if it's already on the main queue, it still needs to be
        // dispatched, or the infinite loop results.
        
        if ([delegate respondsToSelector:@selector(pluginTaskWillStart:)]) {
            // The plugin task delegate must be informed before calculating
            // the environment dictionary in order to assure that the
            // correct window number is returned.
            [delegate pluginTaskWillStart:task];
        }
        
        NSDictionary *environmentDictionary;
        if ([delegate respondsToSelector:@selector(environmentDictionaryForPluginTask:)]) {
            environmentDictionary = [delegate environmentDictionaryForPluginTask:task];
        }
        if (environmentDictionary) {
            [task setEnvironment:environmentDictionary];
        }
        
        BOOL success = NO;
        NSError *error;
        NSString *launchPath = [task launchPath];
        if ([[NSFileManager defaultManager] isExecutableFileAtPath:launchPath]) {
            @try {
                [task launch];
                success = YES;
            }
            @catch (NSException *exception) {
                error = [NSError launchPathExceptionError:launchPath];
                completionHandler(NO);
            }
        } else {
            error = [NSError launchPathUnexecutableError:launchPath];
        }
        
        if (success) {
            if ([delegate respondsToSelector:@selector(pluginTask:didRunCommandPath:arguments:directoryPath:)]) {
                [delegate pluginTask:task didRunCommandPath:commandPath
                           arguments:arguments
                       directoryPath:directoryPath];
            }
        } else {
            if (error == nil) {
                error = [NSError launchPathUnkownError:launchPath];
            }
            
            if ([delegate respondsToSelector:@selector(pluginTask:didFailToRunCommandPath:error:)]) {
                [delegate pluginTask:task didFailToRunCommandPath:launchPath error:error];
            }
        }
    
        if (completionHandler) {
            completionHandler(success);
        }

    });

    return task;
}

+ (void)processStandardOutput:(NSString *)text task:(NSTask *)task delegate:(id<WCLPluginTaskDelegate>)delegate
{
    if ([delegate respondsToSelector:@selector(pluginTask:didReadFromStandardOutput:)]) {
        [delegate pluginTask:task didReadFromStandardOutput:text];
    }
}

+ (void)processStandardError:(NSString *)text task:(NSTask *)task delegate:(id<WCLPluginTaskDelegate>)delegate
{
    if ([delegate respondsToSelector:@selector(pluginTask:didReadFromStandardError:)]) {
        [delegate pluginTask:task didReadFromStandardError:text];
    }
}


@end