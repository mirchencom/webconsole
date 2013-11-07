//
//  WebWindowControllerTestsHelper.m
//  Web Console
//
//  Created by Roben Kleene on 10/21/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WebWindowControllerTestsHelper.h"

#import "Web_ConsoleTestsConstants.h"

#import "WebWindowsController.h"
#import "WebWindowController.h"

#import "Plugin.h"
#import "Plugin+Tests.h"

@implementation WebWindowControllerTestsHelper


#pragma mark - Running Tasks

+ (NSTask *)taskRunningCommandPath:(NSString *)commandPath
{
    NSTask *task;
    [self webWindowControllerRunningCommandPath:commandPath task:&task];
    return task;
}

+ (WebWindowController *)webWindowControllerRunningCommandPath:(NSString *)commandPath
{
    return [self webWindowControllerRunningCommandPath:commandPath task:nil];
}

+ (WebWindowController *)webWindowControllerRunningCommandPath:(NSString *)commandPath task:(NSTask **)task
{
    Plugin *plugin = [[Plugin alloc] init];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    NSAssert([webWindowControllers count], @"The Plugin should have a WebWindowController.");
    WebWindowController *webWindowController = webWindowControllers[0];
    NSAssert([webWindowController.tasks count], @"The WebWindowController should have an NSTask.");
    
    if (task) *task = webWindowController.tasks[0];
    
    return webWindowController;
}


#pragma mark - Window Visible

+ (void)blockUntilWindowIsVisible:(NSWindow *)window
{
    if ([window isVisible]) return;
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (![window isVisible] && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    NSAssert([window isVisible], @"The NSWindow should be visible.");
}


#pragma mark - Attached Sheet

+ (void)blockUntilWindowHasAttachedSheet:(NSWindow *)window
{
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (![window attachedSheet] && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }

    NSAssert([window attachedSheet], @"The NSWindow should have an attached sheet.");
}


#pragma mark - Window Closes

+ (BOOL)windowWillCloseBeforeTimeout:(NSWindow *)window
{
    if (![window isVisible]) return YES;
    
    __block id observer;
    __block BOOL windowWillClose = NO;
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification
                                                                 object:window
                                                                  queue:nil
                                                             usingBlock:^(NSNotification *notification) {
                                                                 [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                 windowWillClose = YES;
                                                             }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while (!windowWillClose && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!windowWillClose) [[NSNotificationCenter defaultCenter] removeObserver:observer];
    
    return windowWillClose;
}

+ (void)closeWindowsAndBlockUntilFinished
{    
    if (![[[WebWindowsController sharedWebWindowsController] webWindowControllers] count]) return;
    
    NSMutableArray *observers = [NSMutableArray array];
    for (WebWindowController *webWindowController in [[WebWindowsController sharedWebWindowsController] webWindowControllers]) {
        __block id observer;
        observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowWillCloseNotification
                                                                     object:webWindowController.window
                                                                      queue:nil
                                                                 usingBlock:^(NSNotification *notification) {
                                                                     [[NSNotificationCenter defaultCenter] removeObserver:observer];
                                                                     [observers removeObject:observer];
                                                                 }];
        [observers addObject:observer];
        
        [webWindowController.window performClose:self];
    }
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:kTestTimeoutInterval];
    while ([observers count] && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    
    BOOL windowsDidFinishClosing = ![observers count] ? YES : NO;
    
    for (id observer in observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    
    NSAssert(windowsDidFinishClosing, @"The NSWindows should have finished closing.");
    
    NSUInteger webWindowControllersCount = [[[WebWindowsController sharedWebWindowsController] webWindowControllers] count];
    NSAssert(!webWindowControllersCount, @"There should not be any WebWindowControllers.");

// There is not way to pause a test until [[[NSApplication sharedApplication] windows] count] goes to zero
// The best we can do is test [[[WebWindowsController sharedWebWindowsController] webWindowControllers] count] which should be
// up to date in tracking windows that are slated to be closed.
//    NSUInteger windowsCount = [[[NSApplication sharedApplication] windows] count];
//    NSAssert(!windowsCount, @"There should not be any Windows.");
}

@end
