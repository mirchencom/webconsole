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

#import "Web_Console-Swift.h"

#import <WebKit/WebKit.h>

NSString * const WCLWebWindowControllerDidCancelCloseWindowNotification = @"WCLWebWindowControllerDidCancelCloseWindowNotification";

@interface WCLWebWindowController () <NSWindowDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) void (^storedCompletionHandler)(BOOL success);
@property (nonatomic, strong) WKNavigation *navigation;
@property (nonatomic, strong) NSMutableDictionary *requestToCompletionHandlerDictionary;
- (void)terminateTasksAndCloseWindow;
- (void)saveWindowFrame;
- (NSString *)windowFrameName;
@property (nonatomic, strong) NSMutableArray *mutableTasks;
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

- (void)awakeFromNib
{
    NSString *windowFrameName = [self windowFrameName];
    if (windowFrameName) {
        [self.window setFrameUsingName:windowFrameName];
    }   
}

- (void)windowWillLoad
{
    if (!self.plugin) {
        return;
    }

//    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:self.plugin];
//    BOOL isFirstWindowController = [webWindowControllers isEqualToArray:@[self]];
//    if (isFirstWindowController) {
//        [self setShouldCascadeWindows:NO];
//    }
}

- (void)windowDidLoad
{
    // TODO: Use a public API for this when it is available, `developerExtrasEnabled` is a private property
    NSRect frame = [[self.window contentView] frame];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.preferences setValue:@YES forKey:@"developerExtrasEnabled"];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];

    // WKWebView *webView = [[WKWebView alloc] init];
    
    webView.navigationDelegate = self;
    [self.window setContentView:webView];
}


#pragma mark - Properties

- (WKWebView *)webView
{
    return self.window.contentView;
}

- (NSMutableDictionary *)requestToCompletionHandlerDictionary
{
    if (_requestToCompletionHandlerDictionary) return _requestToCompletionHandlerDictionary;
    
    _requestToCompletionHandlerDictionary = [NSMutableDictionary dictionary];
    
    return _requestToCompletionHandlerDictionary;
}

#pragma mark - AppleScript

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
    
    // Store the completion handler in a property just until we can map it to a request.
    if (self.storedCompletionHandler) {
        self.storedCompletionHandler(NO);
    }
    self.storedCompletionHandler = completionHandler;
    
    [self.webView loadHTMLString:HTML baseURL:baseURL];
}

- (void)doJavaScript:(NSString *)javaScript completionHandler:(void (^)(id result))completionHandler
{
    [self.webView evaluateJavaScript:javaScript completionHandler:^(id result, NSError *error) {
        completionHandler(result);
    }];
}

#pragma mark - NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender
{
    if ([self hasTasks]) {
        
        NSArray *commands = [self.mutableTasks valueForKey:kLaunchPathKey];

        if (![commands count] && [self.mutableTasks count]) {
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
                [[NSNotificationCenter defaultCenter] postNotificationName:WCLWebWindowControllerDidCancelCloseWindowNotification object:self];
                return;
            }
            
            [self terminateTasksAndCloseWindow];
        }];
        
        return NO;
    }
    
    return YES;
}

- (void)windowWillClose:(NSNotification *)notification {
    [[WCLWebWindowsController sharedWebWindowsController] removeWebWindowController:self];
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
    return self.plugin.name;
}

#pragma mark - Termination

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
                // TODO: If performance becomes a concern, this should be dispatched to another queue
                // Another task could have started while terminating the initial set of tasks
                // so call again recursively
                DLog(@"[Termination] Calling terminateTasksAndCloseWindow recursively because there are still running tasks");
                [self terminateTasksAndCloseWindow];
            }
        });
    }];
}

#pragma mark - WebResourceLoadDelegate

// TODO: Figure out how to disable caching with `WKWebView`

//- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource
//{
//    // TODO: This disables all local caching of resources. This was added to get the HTML plugin to be able to easily refresh updated resources, but a more elegant solution that preserves caching in most cases might be preferable.
//    request = [NSURLRequest requestWithURL:[request URL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:[request timeoutInterval]];
//    return request;
//}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    self.navigation = navigation;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (self.navigation == navigation) {
        self.navigation = nil;
        self.storedCompletionHandler(YES);
        self.storedCompletionHandler = nil;
        [self.window setTitle:self.webView.title];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = [[navigationAction request] URL];
    
    // TODO: This will probably need to be debugged with `WKWebView`
    if (self.navigation || self.storedCompletionHandler) {
        // Always allow the first URL to load
        // If the storedCompletionHandler is not nil, that means a load HTML is being called.
        // Checking if it it's not nil allows a second load HTML with referenced file URLs to be called
        // without the file URL being processed differently per below.
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if ([[URL scheme] isEqualToString:@"file"]) {
        // Handle FILE URLs
        switch (navigationAction.navigationType) {
            case WKNavigationTypeLinkActivated:
                // Links clicked
                [[NSWorkspace sharedWorkspace] openURL:URL];
                decisionHandler(WKNavigationActionPolicyCancel);
                break;
            case WKNavigationTypeOther:
                // JavaScript setting "window.location"
                [[NSWorkspace sharedWorkspace] openURL:URL];
                decisionHandler(WKNavigationActionPolicyCancel);
                break;
            default:
                decisionHandler(WKNavigationActionPolicyAllow);
                break;
        }
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WCLPluginTaskDelegate

- (void)pluginTaskWillStart:(NSTask *)task
{
    [self.window setDocumentEdited:YES]; // Add edited dot in close button
    [self.mutableTasks addObject:task];
}

- (void)pluginTaskDidFinish:(NSTask *)task
{
    [self.mutableTasks removeObject:task];
    if (![self.mutableTasks count]) {
        [self.window setDocumentEdited:NO]; // Remove edited dot in close button
    }
}

- (NSDictionary *)environmentDictionaryForPluginTask:(NSTask *)task
{
    NSMutableDictionary *environmentDictionary;
    NSDictionary *preferencesEnvironmentDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kEnvironmentDictionaryKey];
    if (preferencesEnvironmentDictionary) {
        environmentDictionary = [preferencesEnvironmentDictionary mutableCopy];
    } else {
        environmentDictionary = [[NSMutableDictionary alloc] init];
    }

    NSString *sharedResourcesPath = [[PluginsManager sharedInstance] sharedResourcesPath];
    if (sharedResourcesPath) {
        environmentDictionary[kEnvironmentVariableSharedResourcesPathKey] = sharedResourcesPath;
    }

    NSString *sharedResourcesURL = [[[PluginsManager sharedInstance] sharedResourcesURL] absoluteString];
    if (sharedResourcesURL) {
        environmentDictionary[kEnvironmentVariableSharedResourcesURLKey] = sharedResourcesURL;
    }

    NSString *pluginName = self.plugin.name;
    if (pluginName) {
        environmentDictionary[kEnvironmentVariablePluginNameKey] = pluginName;
    }

    if (![self.window isVisible]) {
        // Setting the windowNumber in the environmentDictionary must happen after showing the window
        [self showWindow:nil];
    }
    NSNumber *windowNumber = [NSNumber numberWithInteger:self.window.windowNumber];
    if (windowNumber) {
        environmentDictionary[kEnvironmentVariableWindowIDKey] = windowNumber;
    }

    return environmentDictionary;
}

#pragma mark - Tasks

- (NSArray *)tasks
{
    return [NSArray arrayWithArray:self.mutableTasks];
}

- (NSMutableArray *)mutableTasks
{
    if (_mutableTasks) {
        return _mutableTasks;
    }

    _mutableTasks = [NSMutableArray array];
    
    return _mutableTasks;
}

- (BOOL)hasTasks
{
    return [self.tasks count] > 0;
}

@end
