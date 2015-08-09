//
//  WebWindowController.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLSplitWebWindowController.h"

#import "WCLUserInterfaceTextHelper.h"

#import "Web_Console-Swift.h"

#import "WCLTaskHelper.h"


NSString * const WCLSplitWebWindowControllerDidCancelCloseWindowNotification = @"WCLSplitWebWindowControllerDidCancelCloseWindowNotification";

@interface WCLSplitWebWindowController () <NSWindowDelegate, SplitWebViewControllerDelegate>
- (void)terminateTasksAndCloseWindow;
- (void)saveWindowFrame;
- (NSString *)windowFrameName;
@property (nonatomic, strong, readonly) SplitWebViewController *splitWebViewController;
@end

@implementation WCLSplitWebWindowController

#pragma mark - Life Cycle

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    NSString *windowFrameName = [self windowFrameName];
    if (windowFrameName) {
        [self.window setFrameUsingName:windowFrameName];
    }   
}

#pragma mark - Properties

- (void)setPlugin:(Plugin *)plugin
{
    self.splitWebViewController.plugin = plugin;
}

- (Plugin *)plugin
{
    return self.splitWebViewController.plugin;
}

- (SplitWebViewController *)splitWebViewController
{
    return (SplitWebViewController *)self.contentViewController;
}

#pragma mark - NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender
{
    if ([self hasTasks]) {
        
        NSArray *tasks = [self tasks];
        NSArray *commands = [tasks valueForKey:kLaunchPathKey];

        if (![commands count] && [tasks count]) {
            // Thread protection for if the last task ended after the hasTasks if statement
            return YES;
        }
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Close"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"Do you want to close this window?"];

        NSString *informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:commands];
        [alert setInformativeText:informativeText];

        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
            if (returnCode != NSAlertFirstButtonReturn) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WCLSplitWebWindowControllerDidCancelCloseWindowNotification object:self];
                return;
            }
            
            [self terminateTasksAndCloseWindow];
        }];
        
        return NO;
    }
    
    return YES;
}

- (void)windowWillClose:(NSNotification *)notification {
    if ([self.delegate respondsToSelector:@selector(splitWebWindowControllerWindowWillClose:)]) {
        [self.delegate splitWebWindowControllerWindowWillClose:self];
    }
}

- (void)windowDidMove:(NSNotification *)notification
{
    [self saveWindowFrame];
}

- (void)windowDidResize:(NSNotification *)notification
{
    [self saveWindowFrame];
}

#pragma mark - Save & Restore Window Frame

- (void)saveWindowFrame
{
    NSString *windowFrameName = [self windowFrameName];
    if (windowFrameName) {
        [self.window saveFrameUsingName:windowFrameName];
    }
}

- (NSString *)windowFrameName
{
    return self.splitWebViewController.plugin.name;
}

#pragma mark - Tasks

- (void)runTask:(NSTask *)task
{
    [self.splitWebViewController runTask:task];
}

- (NSArray *)tasks
{
    return [self.splitWebViewController tasks];
}

- (BOOL)hasTasks
{
    return [self.splitWebViewController hasTasks];
}

- (void)terminateTasksAndCloseWindow
{
    // TODO: When the API allows a WCLSplitWebWindowController to have multiple tasks, this will need additional testing.
    // A test where a new task is created on the WCLSplitWebWindowController after terminateTasks:completionHandler: is called
    // so that the ![self hasTasks] check fails and this method is called recurssively.
    NSArray *tasks = [self tasks];
    [WCLTaskHelper terminateTasks:tasks completionHandler:^(BOOL success) {
        NSAssert(success, @"Terminating NSTasks should always succeed.");

        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self hasTasks]) {
                [self.window close];
            } else {
                // TODO: If performance becomes a concern, this should be dispatched to another queue
                // Another task could have started while terminating the initial set of tasks
                // so call again recursively
                DLog(@"[Termination] Calling terminateTasksAndCloseWindow recursively because there are still running tasks");
                [self terminateTasksAndCloseWindow];
            }
        });
    }];
}

#pragma mark - SplitWebViewControllerDelegate

- (NSNumber *)windowNumberForSplitWebViewController:(SplitWebViewController *)splitWebViewController
{
    if (![self.window isVisible]) {
        // The windowNumber must be calculated after showing the window
        [self showWindow:nil];
    }

    return [NSNumber numberWithInteger:self.window.windowNumber];
}

- (void)splitWebViewControllerWillLoadHTML:(SplitWebViewController *)splitWebViewController
{
    if (![self.window isVisible]) {
        // Showing the window here allows connecting manipulating a window just by loading HTML. I.e., running an script without
        // using the plugin interface. Note that when running a script and using the app this way that some functionality
        // will not work, such as terminating the running process when the window closes.
        [self showWindow:self]; // If showWindow is not before loadHTMLString, then failure completion handler will not fire.
    }
}

- (void)splitWebViewController:(SplitWebViewController *)splitWebViewController didReceiveTitle:(NSString *)title
{
    [self.window setTitle:title];
}


- (void)splitWebViewControllerDidStartTasks:(SplitWebViewController *)splitWebViewController
{
    [self.window setDocumentEdited:YES]; // Add edited dot in close button
}

- (void)splitWebViewControllerDidFinishTasks:(SplitWebViewController *)splitWebViewController
{
    [self.window setDocumentEdited:NO]; // Remove edited dot in close button
}


@end
