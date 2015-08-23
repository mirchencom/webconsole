//
//  WCLWebViewController.m
//  Web Console
//
//  Created by Roben Kleene on 8/7/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import "WCLWebViewController.h"

#import <WebKit/WebKit.h>

#import "WCLPluginTask.h"
#import "Web_Console-Swift.h"

@interface WCLWebViewController ()
@property (weak) IBOutlet WebView *webView;
@property (nonatomic, strong) void (^storedCompletionHandler)(BOOL success);
@property (nonatomic, strong) NSMutableDictionary *requestToCompletionHandlerDictionary;
@property (nonatomic, strong) NSMutableArray *mutableTasks;
@end

@implementation WCLWebViewController

@synthesize identifier=_identifier;

#pragma mark - Life Cycle

- (void)viewWillAppear
{
    [super viewWillAppear];
    if ([self.delegate respondsToSelector:@selector(webViewControllerViewWillAppear:)]) {
        [self.delegate webViewControllerViewWillAppear:self];
    }

}

- (void)viewWillDisappear
{
    [super viewWillDisappear];
    if ([self.delegate respondsToSelector:@selector(webViewControllerViewWillDisappear:)]) {
        [self.delegate webViewControllerViewWillDisappear:self];
    }
}

#pragma mark - Properties

- (NSMutableDictionary *)requestToCompletionHandlerDictionary
{
    if (_requestToCompletionHandlerDictionary) return _requestToCompletionHandlerDictionary;
    
    _requestToCompletionHandlerDictionary = [NSMutableDictionary dictionary];
    
    return _requestToCompletionHandlerDictionary;
}

- (NSString * __nonnull)identifier
{
    if (_identifier) {
        return _identifier;
    }

    _identifier = [[NSUUID UUID] UUIDString];

    return _identifier;
}

#pragma mark - AppleScript

- (void)loadHTML:(NSString *)HTML baseURL:(NSURL *)baseURL completionHandler:(void (^)(BOOL success))completionHandler {
    
    if ([self.delegate respondsToSelector:@selector(webViewControllerWillLoadHTML:)]) {
        [self.delegate webViewControllerWillLoadHTML:self];
    }
    
    // Store the completion handler in a property just until we can map it to a request.
    self.storedCompletionHandler = completionHandler;
    
    [self.webView.mainFrame loadHTMLString:HTML baseURL:baseURL];
}

- (NSString *)doJavaScript:(NSString *)javaScript {
    return [self.webView stringByEvaluatingJavaScriptFromString:javaScript];
}

#pragma mark - WebPolicyDelegate

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource
{
    // TODO: This disables all local caching of resources. This was added to get the HTML plugin to be able to easily refresh updated resources, but a more elegant solution that preserves caching in most cases might be preferable.
    request = [NSURLRequest requestWithURL:[request URL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:[request timeoutInterval]];
    return request;
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    NSURL *URL = [request URL];
    
    if (![webView mainFrameURL] ||
        self.storedCompletionHandler) {
        // Always allow the first URL to load
        // If the storedCompletionHandler is not nil, that means a load HTML is being called.
        // Checking if it it's not nil allows a second load HTML with a file URL to be called without the file URL being processed separately.
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

- (void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    [listener use];
}

#pragma mark - WebResourceLoadDelegate

- (id)webView:(WebView *)sender identifierForInitialRequest:(NSURLRequest *)request fromDataSource:(WebDataSource *)dataSource
{
    if (self.storedCompletionHandler) {
        self.requestToCompletionHandlerDictionary[request] = self.storedCompletionHandler;
        self.storedCompletionHandler = nil;
    }
    
    return request;
}

- (void)webView:(WebView *)sender resource:(id)identifier didFinishLoadingFromDataSource:(WebDataSource *)dataSource
{
    void (^completionHandler)(BOOL success) = self.requestToCompletionHandlerDictionary[identifier];
    if (completionHandler) {
        completionHandler(YES);
        [self.requestToCompletionHandlerDictionary removeObjectForKey:identifier];
    }
}

- (void)webView:(WebView *)sender resource:(id)identifier didFailLoadingWithError:(NSError *)error fromDataSource:(WebDataSource *)dataSource
{
    void (^completionHandler)(BOOL success) = self.requestToCompletionHandlerDictionary[identifier];
    if (completionHandler) {
        completionHandler(NO);
        [self.requestToCompletionHandlerDictionary removeObjectForKey:identifier];
    }
}

#pragma mark - WebFrameLoadDelegate

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    if ([self.delegate respondsToSelector:@selector(webViewController:didReceiveTitle:)]) {
        [self.delegate webViewController:self didReceiveTitle:title];
    }
}

#pragma mark - WCLPluginTaskDelegate

- (void)pluginTaskWillStart:(NSTask *)task
{
    if ([self.delegate respondsToSelector:@selector(webViewController:taskWillStart:)]) {
        [self.delegate webViewController:self taskWillStart:task];
    }

    [self.mutableTasks addObject:task];
}

- (void)pluginTaskDidFinish:(NSTask *)task
{
    [self.mutableTasks removeObject:task];

    if ([self.delegate respondsToSelector:@selector(webViewController:taskDidFinish:)]) {
        [self.delegate webViewController:self taskDidFinish:task];
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
    
    NSWindow *window = [self.delegate windowForWebViewController:self];
    if (window) {
        if (![window isVisible]) {
            // The windowNumber must be calculated after showing the window
            [window.windowController showWindow:nil];
        }
        NSNumber *windowNumber = [NSNumber numberWithInteger:window.windowNumber];
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
