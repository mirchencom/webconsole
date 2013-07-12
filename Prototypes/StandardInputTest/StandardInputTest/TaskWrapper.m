//
//  TaskWrapper.m
//  StandardInputTest
//
//  Created by Roben Kleene on 7/10/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "TaskWrapper.h"

@implementation TaskWrapper

- (void)passTextToCommand:(NSString *)text
{
    // I can do this just by accessing task.standardInput
    [self.fileHandleForWriting writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];

    
//    [self.fileHandleForWriting closeFile];
//[self.fileHandleForWriting synchronizeFile];
    
    
    
    
    //NSLog(@"self.fileHandleForWriting = %@", self.fileHandleForWriting);
//NSLog(@"self.task.standardInput = %@", self.task.standardInput);
//    
//    NSData *data = [self.fileHandleForWriting availableData];
//    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//
//    NSString *output = [[NSString alloc] initWithData:[self.fileHandleForWriting readDataToEndOfFile] encoding:NSUTF8StringEncoding];
//    NSLog(@"output = %@", output);
//    [self.task interrupt];
//    [self.task terminate];

    
//    NSLog(@"Passing Text %@", text);
}

- (void)runCommandAtPath:(NSString *)commandPath
{
    self.task = [[NSTask alloc] init];
    [self.task setLaunchPath:commandPath];
    
    NSString *directoryPath = [commandPath stringByDeletingLastPathComponent];
    [self.task setCurrentDirectoryPath:directoryPath];
    
    NSMutableDictionary *environmentDictionary = [[NSMutableDictionary alloc] init];
    environmentDictionary[kEnvironmentVariablePathKey] = kEnvironmentVariablePathValue;
    [self.task setEnvironment:environmentDictionary];

    // I can do this just by accessing task.standardInput
    NSPipe *inputPipe = [NSPipe pipe];
    self.fileHandleForWriting = [inputPipe fileHandleForWriting];

    [self.task setStandardInput:inputPipe];
    
    self.task.standardOutput = [NSPipe pipe];
    
    [[self.task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSLog(@"Standard Output");
        
        NSData *data = [file availableData];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];

    self.task.standardError = [NSPipe pipe];
    [[self.task.standardError fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSLog(@"Standard Error");
        
        NSData *data = [file availableData];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    [self.task setTerminationHandler:^(NSTask *task) {
        NSLog(@"Termination Handler");
        
        [[task.standardOutput fileHandleForReading] setReadabilityHandler:nil];
        
        //        [task.standardError fileHandleForReading].readabilityHandler = nil;
        //        BOOL success = [task terminationStatus] == 0;
        //        completionHandler(success);
    }];
    
    NSLog(@"Task Launch");
    
    [self.task launch];
}


@end
