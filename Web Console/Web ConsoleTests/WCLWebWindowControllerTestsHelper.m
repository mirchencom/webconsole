//
//  WebWindowControllerTestsHelper.m
//  Web Console
//
//  Created by Roben Kleene on 10/21/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLWebWindowControllerTestsHelper.h"

#import "Web_ConsoleTestsConstants.h"

#import "WCLWebWindowsController.h"
#import "WCLWebWindowController.h"

#import "WCLTaskTestsHelper.h"

#import "WCLPlugin.h"
#import "WCLPlugin+Tests.h"

@implementation WCLWebWindowControllerTestsHelper


#pragma mark - Running Tasks

+ (NSTask *)taskRunningCommandPath:(NSString *)commandPath
{
    NSTask *task;
    (void)[self webWindowControllerRunningCommandPath:commandPath task:&task];
    return task;
}

+ (WCLWebWindowController *)webWindowControllerRunningCommandPath:(NSString *)commandPath
{
    return [self webWindowControllerRunningCommandPath:commandPath task:nil];
}

+ (WCLWebWindowController *)webWindowControllerRunningCommandPath:(NSString *)commandPath task:(NSTask **)task
{
    WCLPlugin *plugin = [[WCLPlugin alloc] init];
    [plugin runCommandPath:commandPath withArguments:nil withResourcePath:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    NSAssert([webWindowControllers count], @"The WCLPlugin should have a WCLWebWindowController.");
    WCLWebWindowController *webWindowController = webWindowControllers[0];
    NSAssert([webWindowController hasTasks], @"The WCLWebWindowController should have an NSTask.");
    
    if (task) *task = webWindowController.tasks[0];

    [WCLTaskTestsHelper blockUntilTaskIsRunning:webWindowController.tasks[0]];
    
    return webWindowController;
}

+ (void)blockUntilWebWindowControllerTasksRunAndFinish:(WCLWebWindowController *)webWindowController
{
    [WCLTaskTestsHelper blockUntilTasksRunAndFinish:webWindowController.tasks];
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
    if (![[[WCLWebWindowsController sharedWebWindowsController] webWindowControllers] count]) return;
    
    NSMutableArray *observers = [NSMutableArray array];
    for (WCLWebWindowController *webWindowController in [[WCLWebWindowsController sharedWebWindowsController] webWindowControllers]) {
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
    
    NSUInteger webWindowControllersCount = [[[WCLWebWindowsController sharedWebWindowsController] webWindowControllers] count];
    NSAssert(!webWindowControllersCount, @"There should not be any WCLWebWindowControllers.");

// There is not way to pause a test until [[[NSApplication sharedApplication] windows] count] goes to zero
// The best we can do is test [[[WebWindowsController sharedWebWindowsController] webWindowControllers] count] which should be
// up to date in tracking windows that are slated to be closed.
//    NSUInteger windowsCount = [[[NSApplication sharedApplication] windows] count];
//    NSAssert(!windowsCount, @"There should not be any Windows.");
}

@end
