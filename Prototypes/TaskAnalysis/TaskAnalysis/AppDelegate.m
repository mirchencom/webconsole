//
//  AppDelegate.m
//  TaskAnalysis
//
//  Created by Roben Kleene on 7/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *launchPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"sh"];
    
    NSTask *task = [[NSTask alloc] init];
    
    
    NSMutableDictionary *environmentDictionary = [[NSMutableDictionary alloc] init];
    environmentDictionary[@"PATH"] = @"/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
    
    [task setEnvironment:environmentDictionary];
    
    
    [task setLaunchPath:launchPath];
    task.standardOutput = [NSPipe pipe];
    
    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSLog(@"Done");
        
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