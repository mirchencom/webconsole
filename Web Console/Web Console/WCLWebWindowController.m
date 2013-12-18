//
//  WebWindowController.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLWebWindowController.h"

#import "WCLWebWindowsController.h"

#import "WCLUserInterfaceTextHelper.h"

#import "WCLTaskHelper.h"

NSString * const WCLWebWindowControllerDidCancelCloseWindowNotification = @"WCLWebWindowControllerDidCancelCloseWindowNotification";

@interface WCLWebWindowController () <NSWindowDelegate>
@property (weak) IBOutlet WebView *webView;
@property (nonatomic, strong) void (^completionHandler)(BOOL success);
- (void)terminateTasksAndCloseWindow;
@property (nonatomic, strong) NSMutableArray *mutableTasks;
@property (nonatomic, strong) WCLPlugin *plugin;
@end

@implementation WCLWebWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)loadHTML:(NSString *)HTML completionHandler:(void (^)(BOOL))completionHandler {
    [self loadHTML:HTML baseURL:nil completionHandler:completionHandler];
}

- (void)loadHTML:(NSString *)HTML baseURL:(NSURL *)baseURL completionHandler:(void (^)(BOOL success))completionHandler {

    if (![self.window isVisible]) {
        // Showing the window here allows connecting manipulating a window just by loading HTML. I.e., running an script without
        // using the plugin interface. Note that when running a script and using the app this way that some functionality
        // will not work, such as terminating the running process when the window closes.
        [self showWindow:self]; // If showWindow is not before loadHTMLString, then failure completion handler will not fire.
    }

    [self.webView.mainFrame loadHTMLString:HTML baseURL:baseURL];
    
    self.completionHandler = completionHandler;
}

- (NSString *)doJavaScript:(NSString *)javaScript {
    return [self.webView stringByEvaluatingJavaScriptFromString:javaScript];
}

#pragma mark - NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender
{
    if ([self hasTasks]) {
        
        NSArray *commands = [self.mutableTasks valueForKey:kLaunchPathKey];

        if (![commands count] && [self.mutableTasks count]) return YES; // Thread protection for if the last task ended after the hasTasks if statement
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Close"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"Do you want to close this window?"];
        
        
        NSString *informativeText = [WCLUserInterfaceTextHelper informativeTextForCloseWindowForCommands:commands];
        [alert setInformativeText:informativeText];
        [alert beginSheetModalForWindow:self.window
                          modalDelegate:self
                         didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
                            contextInfo:NULL];        
        return NO;

    
    }
    
    return YES;
}

- (void)windowWillClose:(NSNotification *)notification {
    [[WCLWebWindowsController sharedWebWindowsController] removeWebWindowController:self];
}

#pragma mark - Modal Delegate

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode != NSAlertFirstButtonReturn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WCLWebWindowControllerDidCancelCloseWindowNotification object:self];
        return;
    }

    [self terminateTasksAndCloseWindow];
}

- (void)terminateTasksAndCloseWindow
{
    // TODO: When the API allows a WCLWebWindowController to have multiple tasks, this will need additional testing.
    // A test where a new task is created on the WCLWebWindowController after terminateTasks:completionHandler: is called
    // so that the ![self hasTasks] check fails and this method is called recurssively.
    [WCLTaskHelper terminateTasks:self.mutableTasks completionHandler:^(BOOL success) {
        NSAssert(success, @"Terminating NSTasks should always succeed.");

        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self hasTasks]) {
                [self.window close];
            } else {
#warning If performance becomes a concern, this should be dispatched to another queue
                // Another task could have started while terminating the initial set of tasks
                // so call again recursively
                DLog(@"Calling terminateTasksAndCloseWindow recursively because there are still running tasks");
                [self terminateTasksAndCloseWindow];
            }
        });
    }];
}

#pragma mark - WebPolicyDelegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
    NSURL *URL = [request URL];

    if (![webView mainFrameURL]) {
        // Always allow the first URL to load
        [listener use];
        return;
    }

    if ([[URL scheme] isEqualToString:@"file"]) {
        // Handle FILE URLs
        switch ([actionInformation[@"WebActionNavigationTypeKey"] intValue]) {
            case WebNavigationTypeLinkClicked:
                // Links clicked
                [[NSWorkspace sharedWorkspace] openURL:[request URL]];
                break;
            case WebNavigationTypeOther:
                // JavaScript setting "window.location"
                [[NSWorkspace sharedWorkspace] openURL:[request URL]];
                break;
            default:
                [listener use];
                break;
        }
        return;
    }

    [listener use];
}

- (void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
    NSLog(@"type = %@", type);
    
    [listener use];
}

#pragma mark - WebResourceLoadDelegate

- (void)webView:(WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(WebDataSource *)dataSource {
    self.completionHandler(YES);
}

- (void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource {    
    self.completionHandler(NO);
}

#pragma mark - WebFrameLoadDelegate

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {
    [self.window setTitle:title];
}

#pragma mark - Tasks

- (NSArray *)tasks
{
    return [NSArray arrayWithArray:self.mutableTasks];
}

- (NSMutableArray *)mutableTasks
{
    if (_mutableTasks) return _mutableTasks;    
    _mutableTasks = [NSMutableArray array];
    return _mutableTasks;
}

- (BOOL)hasTasks
{
    return [self.tasks count] > 0;
}

@end
