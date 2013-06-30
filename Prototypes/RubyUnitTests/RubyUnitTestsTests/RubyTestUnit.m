//
//  RubyTestUnit.m
//  RubyUnitTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "RubyTestUnit.h"

#define kDefaultRuby @"/usr/bin/ruby"

@implementation RubyTestUnit

+ (void)runTestWithContentsOfURL:(NSURL *)URL completionHandler:(void (^)(BOOL success))completionHandler {
    NSTask *task = [[NSTask alloc] init];

    [task setLaunchPath:kDefaultRuby];
    [task setArguments:@[[URL path]]];
    task.standardOutput = [NSPipe pipe];

    [[task.standardOutput fileHandleForReading] setReadabilityHandler:^(NSFileHandle *file) {
        NSData *data = [file availableData];
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

        NSLog(@"blah");
    }];
    
    [task setTerminationHandler:^(NSTask *task) {
        [[task.standardOutput fileHandleForReading] setReadabilityHandler:nil];
//        [task.standardError fileHandleForReading].readabilityHandler = nil;
        BOOL success = [task terminationStatus] == 0;
        completionHandler(success);
    }];
    
    [task launch];
    
//    NSPipe *pipe = [NSPipe pipe];
//    [task setStandardOutput:pipe];
    
//    NSFileHandle *file = [pipe fileHandleForReading];
//    NSData *data = [file readDataToEndOfFile];
//    
//    NSString *output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//    NSLog(@"%@", output);

}
@end
