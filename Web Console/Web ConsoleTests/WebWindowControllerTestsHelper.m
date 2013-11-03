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

@implementation WebWindowControllerTestsHelper

+ (BOOL)windowWillCloseBeforeTimeout:(NSWindow *)window
{
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
    
    NSAssert(windowsDidFinishClosing, @"The windows should have finished closing.");
    
    NSUInteger webWindowControllersCount = [[[WebWindowsController sharedWebWindowsController] webWindowControllers] count];
    NSAssert(!webWindowControllersCount, @"There should not be any WebWindowControllers.");

// There is not way to pause a test until [[[NSApplication sharedApplication] windows] count] goes to zero
// The best we can do is test [[[WebWindowsController sharedWebWindowsController] webWindowControllers] count] which should be
// up to date in tracking windows that are slated to be closed.
//    NSUInteger windowsCount = [[[NSApplication sharedApplication] windows] count];
//    NSAssert(!windowsCount, @"There should not be any Windows.");
}

@end
