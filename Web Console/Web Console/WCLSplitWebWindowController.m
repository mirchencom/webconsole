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
@property (nonatomic, readonly) Plugin *logPlugin;
- (void)terminateTasksAndCloseWindow;
- (void)saveWindowFrame;
- (NSString *)windowFrameName;
@end

@implementation WCLSplitWebWindowController

@synthesize logPlugin = _logPlugin;

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
    // TODO: Cascade windows doesn't seem to be working since converting to a storyboard
//    [self setShouldCascadeWindows:YES]; // This should be the default, but it's not since switching to a storyboard
    self.splitWebViewController.delegate = self;
}

#pragma mark - Properties

- (Plugin *)plugin
{
    return self.splitWebViewController.plugin;
}

- (Plugin *)logPlugin
{
    if (_logPlugin) {
        return _logPlugin;
    }
    
    if ([self.delegate respondsToSelector:@selector(logPluginForSplitWebWindowController:)]) {
        _logPlugin = [self.delegate logPluginForSplitWebWindowController:self];
    }

    return _logPlugin;
}

- (SplitWebViewController *)splitWebViewController
{
    return (SplitWebViewController *)self.contentViewController;
}

#pragma mark - Helpers

- (nonnull NSArray *)commandsNotRequiringConfirmation
{
    NSString *logCommandPath = self.logPlugin.commandPath;
    if (logCommandPath) {
        return @[logCommandPath];
    }
    
    return @[];
}

- (nonnull NSArray *)commandsRequiringConfirmation
{
    NSArray *tasks = [self tasks];
    NSArray *commands = [tasks valueForKey:kLaunchPathKey];
    
    if (![commands count] && [tasks count]) {
        return @[];
    }
    
    NSMutableArray *commandsRequiringConfirmation = [commands mutableCopy];
    
    // Remove the log from the commands requiring confirmation
    [commandsRequiringConfirmation removeObjectsInArray:[self commandsNotRequiringConfirmation]];
    
    return commandsRequiringConfirmation;
}

- (BOOL)hasTasksRequiringConfirmation
{
    return [[self commandsRequiringConfirmation] count] > 0;
}

#pragma mark - NSWindowDelegate

- (void)showWindow:(id)sender
{
    [self restoreWindowFrame];
    [super showWindow:sender];
}

- (BOOL)windowShouldClose:(id)sender
{
    if (![self hasTasks]) {
        return YES;
    }
    
    NSArray *commandsRequiringConfirmation = [self commandsRequiringConfirmation];
    if (![commandsRequiringConfirmation count]) {
        [self terminateTasksAndCloseWindow];
        return NO;
    }
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"Close"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Do you want to close this window?"];

    NSString *informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:commandsRequiringConfirmation];
    [alert setInformativeText:informativeText];

    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode != NSAlertFirstButtonReturn) {
            [[NSNotificationCenter defaultCenter] postNotificationName:WCLSplitWebWindowControllerDidCancelCloseWindowNotification
                                                                object:self];
            return;
        }
        
        [self terminateTasksAndCloseWindow];
    }];
    
    return NO;
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

- (void)restoreWindowFrame
{
    NSString *windowFrameName = [self windowFrameName];
    if (windowFrameName) {
        [self.window setFrameUsingName:windowFrameName];
    }
}

- (void)saveWindowFrame
{
    // Don't save the frame while the window is being constructed
    if ([self.window isVisible]) {
        NSString *windowFrameName = [self windowFrameName];
        if (windowFrameName) {
            [self.window saveFrameUsingName:windowFrameName];
        }
    }
}

- (NSString *)windowFrameName
{
    return self.splitWebViewController.plugin.name;
}

#pragma mark - AppleScript

- (NSString *)doJavaScript:(NSString *)javaScript
{
    return [self.splitWebViewController doJavaScript:javaScript];
}

- (void)loadHTML:(nonnull NSString *)HTML
         baseURL:(nullable NSURL *)baseURL
completionHandler:(nullable void (^)(BOOL success))completionHandler
{
    [self.splitWebViewController loadHTML:HTML
                                  baseURL:baseURL
                        completionHandler:completionHandler];
}

- (void)readFromStandardInput:(nonnull NSString *)text
{
    return [self.splitWebViewController readFromStandardInputWithText:text];
}

- (void)runPlugin:(nonnull Plugin *)plugin
    withArguments:(nullable NSArray *)arguments
  inDirectoryPath:(nullable NSString *)directoryPath
completionHandler:(nullable void (^)(BOOL success))completionHandler
{
    [self.window setTitle:plugin.name];

    [self.splitWebViewController runWithPlugin:plugin
                             withArguments:arguments
                           inDirectoryPath:directoryPath
                         completionHandler:completionHandler];
}

- (nonnull NSArray<WCLWebViewController *> *)webViewControllers
{
    return self.splitWebViewController.webViewControllers;
}

- (void)showLog
{
    [self.splitWebViewController showLog];
}

- (void)hideLog
{
    [self.splitWebViewController hideLog];
}

- (void)toggleLog
{
    [self.splitWebViewController toggleLog];
}

#pragma mark - Tasks

- (nonnull NSArray<NSTask *> *)tasks;
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

- (NSWindow *)windowFor:(SplitWebViewController *)splitWebViewController
{
    return self.window;
}

- (BOOL)windowIsVisibleFor:(SplitWebViewController * __nonnull)splitWebViewController
{
    return self.window.isVisible;
}

- (Plugin * __nullable)logPluginFor:(SplitWebViewController * __nonnull)splitWebViewController
{
    return self.logPlugin;
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

- (void)splitWebViewController:(SplitWebViewController *)splitWebViewController
               didReceiveTitle:(NSString *)title
{
    [self.window setTitle:title];
}

- (void)splitWebViewController:(SplitWebViewController *)splitWebViewController
                 willStartTask:(NSTask *)task
{
    // `willStartTask` is always called on the main queue
    
    if (![self.window isVisible]) {
        // The windowNumber must be calculated after showing the window
        [self showWindow:nil];
    }
    
    // Add edited dot in close button
    [self.window setDocumentEdited:[self hasTasksRequiringConfirmation]];
}

- (void)splitWebViewController:(SplitWebViewController *)splitWebViewController
                 didFinishTask:(NSTask *)task
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Remove edited dot in close button
        [self.window setDocumentEdited:[self hasTasksRequiringConfirmation]];
    });
}

- (void)splitWebViewController:(SplitWebViewController *)splitWebViewController
              didFailToRunTask:(NSTask *)task
                         error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Remove edited dot in close button
        [self.window setDocumentEdited:[self hasTasksRequiringConfirmation]];
    });
}

@end
