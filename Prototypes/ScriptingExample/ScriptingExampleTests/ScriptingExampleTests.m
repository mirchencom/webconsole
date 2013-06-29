//
//  ScriptingExampleTests.m
//  ScriptingExampleTests
//
//  Created by Roben Kleene on 5/5/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "ScriptingExampleTests.h"

#pragma mark - General
#define kTestScriptsSubdirectory @"TestScripts"

#pragma mark - Extensions
#define kTestScriptsExtension @"scpt"

#pragma mark - Files
#define kTestScriptFilename @"ScriptingExample"

@implementation ScriptingExampleTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{

    NSAppleEventDescriptor *result = [ScriptingExampleTests resultOfRunningTestScriptWithName:kTestScriptFilename];
    NSLog(@"result = %@", result);
    //    STFail(@"Unit tests are not implemented yet in ScriptingExampleTests");
}

+ (NSAppleEventDescriptor *)resultOfRunningTestScriptWithName:(NSString *)name {
//+ (NSAppleEventDescriptor *)resultOfRunningTestScriptWithName:(NSString *)name parameters:(NSAppleEventDescriptor *)parameters {
    NSAppleScript *appleScript = [[self class] appleScriptFromTestBundleWithName:name];
    
//    ProcessSerialNumber psn = {0, kCurrentProcess};
//    NSAppleEventDescriptor *target = [NSAppleEventDescriptor descriptorWithDescriptorType:typeProcessSerialNumber
//                                                                                    bytes:&psn
//                                                                                   length:sizeof(ProcessSerialNumber)];
//    NSAppleEventDescriptor *event = [NSAppleEventDescriptor appleEventWithEventClass:kCoreEventClass
//                                                                             eventID:kAEOpenApplication
//                                                                    targetDescriptor:target
//                                                                            returnID:kAutoGenerateReturnID
//                                                                       transactionID:kAnyTransactionID];
//    [event setParamDescriptor:parameters forKeyword:keyDirectObject];
    
//    NSDictionary *errorInfo;
//    NSAppleEventDescriptor *result = [appleScript executeAppleEvent:event error:&errorInfo];

    NSDictionary *errorInfo;
    NSAppleEventDescriptor *result = [appleScript executeAndReturnError:&errorInfo];
    
    NSString *errorMessage = [NSString stringWithFormat:@"Error executing AppleScript %@", errorInfo];
    NSAssert(!errorInfo, errorMessage);
    
    return result;
}

+ (NSAppleScript *)appleScriptFromTestBundleWithName:(NSString *)name {
    NSURL *appleScriptFileURL = [ScriptingExampleTests fileURLForTestResource:name withExtension:kTestScriptsExtension];
    NSString *errorMessage = [NSString stringWithFormat:@"AppleScript file URL is nil"];
    NSAssert(appleScriptFileURL, errorMessage);
    
    NSDictionary *errorInfo;
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithContentsOfURL:appleScriptFileURL error:&errorInfo];
    
    errorMessage = [NSString stringWithFormat:@"Error initializing AppleScript %@", errorInfo];
    NSAssert(!errorInfo, errorMessage);
    
    return appleScript;
}

+ (NSURL *)fileURLForTestResource:(NSString *)name withExtension:(NSString *)ext {
    return [[NSBundle bundleForClass:[ScriptingExampleTests class]] URLForResource:name
                                                                withExtension:ext
                                                                 subdirectory:kTestScriptsSubdirectory];
}

@end
