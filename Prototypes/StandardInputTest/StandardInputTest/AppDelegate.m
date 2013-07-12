//
//  AppDelegate.m
//  StandardInputTest
//
//  Created by Roben Kleene on 7/9/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "AppDelegate.h"

#import "TaskWrapper.h"

@interface AppDelegate ()
@property (nonatomic, strong) TaskWrapper *taskWrapper;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *commandPath = [[NSBundle mainBundle] pathForResource:kCommandName ofType:kCommandExtension inDirectory:kCommandDirectory];

    self.taskWrapper = [[TaskWrapper alloc] init];
    [self.taskWrapper runCommandAtPath:commandPath];

    
    
//    NSLog(@"commandPath = %@", commandPath);
//    NSString *directoryPath = [commandPath stringByDeletingLastPathComponent];
//    NSLog(@"directoryPath = %@", directoryPath);


//    inputPipe = [[NSPipe alloc] init];
//    inputHandle = [inputPipe fileHandleForWriting];
//[myTask setStandardInput:inputPipe];
//    [inputHandle writeData:[[kci UserPass] dataUsingEncoding:NSUTF8StringEncoding]];

    [self performSelector:@selector(testIt:) withObject:nil afterDelay:1.0];

//    [self performSelector:@selector(endIt:) withObject:nil afterDelay:2.0];
}

- (void)testIt:(id)sender {
    [self.taskWrapper passTextToCommand:@"1 + 1\n"];
}

//- (void)endIt:(id)sender {
//    [self.taskWrapper.task interrupt];
//}


@end
