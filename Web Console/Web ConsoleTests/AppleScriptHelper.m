//
//  AppleScriptHelper.m
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "AppleScriptHelper.h"

#define kTestScriptsSubdirectory @"TestScripts"
#define kTestScriptsExtension @"scpt"

#ifndef kASAppleScriptSuite
#define kASAppleScriptSuite 'ascr'
#endif

#ifndef kASSubroutineEvent
#define kASSubroutineEvent 'psbr'
#endif

#ifndef keyASSubroutineName
#define keyASSubroutineName 'snam'
#endif

@interface AppleScriptHelper ()
+ (NSAppleScript *)appleScriptFromTestBundleWithName:(NSString *)name;
@end

@implementation AppleScriptHelper

+ (NSAppleEventDescriptor *)resultOfRunningTestScriptWithName:(NSString *)name parameters:(NSAppleEventDescriptor *)parameters {
    NSAppleScript *appleScript = [[self class] appleScriptFromTestBundleWithName:name];

    ProcessSerialNumber psn = {0, kCurrentProcess};
    NSAppleEventDescriptor *target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber
                                                                                    bytes:&psn
                                                                                   length:sizeof(ProcessSerialNumber)];
    NSAppleEventDescriptor *event = [NSAppleEventDescriptor appleEventWithEventClass:kCoreEventClass
                                                                             eventID:kAEOpenApplication
                                                                    targetDescriptor:target
                                                                            returnID:kAutoGenerateReturnID
                                                                       transactionID:kAnyTransactionID];
    [event setParamDescriptor:parameters forKeyword:keyDirectObject];
    
    NSDictionary *errorInfo;
    NSAppleEventDescriptor *result = [appleScript executeAppleEvent:event error:&errorInfo];
    
    NSString *errorMessage = [NSString stringWithFormat:@"Error executing AppleScript %@", errorInfo];
    NSAssert(!errorInfo, errorMessage);
    
    return result;
}

+ (NSAppleScript *)appleScriptFromTestBundleWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *appleScriptFileURL = [bundle URLForResource:name
                                          withExtension:kTestScriptsExtension
                                           subdirectory:kTestScriptsSubdirectory];
    
    NSDictionary *errorInfo;
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithContentsOfURL:appleScriptFileURL error:&errorInfo];
    
    NSString *errorMessage = [NSString stringWithFormat:@"Error initializing AppleScript %@", errorInfo];
    NSAssert(!errorInfo, errorMessage);
    
    return appleScript;
}


@end
