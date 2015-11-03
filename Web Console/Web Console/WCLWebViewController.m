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
@property (nonatomic, strong, readwrite, nullable) Plugin *plugin;
@end

@implementation WCLWebViewController

@synthesize identifier = _identifier;

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

#pragma mark - WCLPluginView

- (void)readFromStandardInput:(NSString *)text
{
    if (![self hasTasks]) {
        return;
    }
        
    NSTask *task = self.tasks[0];
    NSPipe *pipe = [task standardInput];
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];

    if (!data) {
        return;
    }
    
    [pipe.fileHandleForWriting writeData:data];

    if ([self.delegate respondsToSelector:@selector(webViewController:didReadFromStandardInput:)]) {
        [self.delegate webViewController:self didReadFromStandardInput:text];
    }
}

- (void)loadHTML:(NSString *)HTML baseURL:(NSURL *)baseURL completionHandler:(void (^)(BOOL success))completionHandler {
    
    if ([self.delegate respondsToSelector:@selector(webViewControllerWillLoadHTML:)]) {
        [self.delegate webViewControllerWillLoadHTML:self];
    }
    
    // Store the completion handler in a property just until we can map it to a request.
    self.storedCompletionHandler = completionHandler;
    
    [self.webView.mainFrame loadHTMLString:HTML baseURL:baseURL];
}

- (NSString *)doJavaScript:(NSString *)javaScript {
    if ([self.delegate respondsToSelector:@selector(webViewController:willDoJavaScript:)]) {
        [self.delegate webViewController:self willDoJavaScript:javaScript];
    }
    
    return [self.webView stringByEvaluatingJavaScriptFromString:javaScript];
}

- (void)runPlugin:(nonnull Plugin *)plugin
    withArguments:(nullable NSArray *)arguments
  inDirectoryPath:(nullable NSString *)directoryPath
completionHandler:(nullable void (^)(BOOL success))completionHandler
{
    if (self.plugin) {
        completionHandler(NO);
        return;
    }

    self.plugin = plugin;

    (void)[WCLPluginTask runTaskWithCommandPath:plugin.commandPath
                            withArguments:arguments
                          inDirectoryPath:directoryPath
                                 delegate:self
                        completionHandler:completionHandler];
}

#pragma mark - WebResourceLoadDelegate

- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource
{
    // TODO: This disables all local caching of resources. This was added to get
    // the HTML plugin to be able to easily refresh updated resources, but a
    // more elegant solution that preserves caching in most cases might be
    // preferable.
    // Additionally, now the app is initialized with an zero memory empty
    // cache on disk.
    request = [NSURLRequest requestWithURL:[request URL]
                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                           timeoutInterval:[request timeoutInterval]];
    return request;
}

#pragma mark - WebPolicyDelegate

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
    // Add the task before calling the delegate, so the delegate gets the
    // expected result when inspecting this classes tasks
    // (e.g., `[thisObject hasTasks]` is true)
    [self.mutableTasks addObject:task];
    
    if ([self.delegate respondsToSelector:@selector(webViewController:willStartTask:)]) {
        [self.delegate webViewController:self willStartTask:task];
    }
}

- (void)pluginTaskDidFinish:(NSTask *)task
{
    // Remove the task before calling the delegate, so the delegate gets the
    // expected result when inspecting this classes tasks
    // (e.g., `[thisObject hasTasks]` may be false)

    [self.mutableTasks removeObject:task];

    if ([self.delegate respondsToSelector:@selector(webViewController:didFinishTask:)]) {
        [self.delegate webViewController:self didFinishTask:task];
    }
}

- (void)pluginTask:(NSTask *)task didRunCommandPath:(NSString *)commandPath
         arguments:(NSArray *)arguments
     directoryPath:(NSString *)directoryPath
{
    if ([self.delegate respondsToSelector:@selector(webViewController:didRunCommandPath:arguments:directoryPath:)]) {
        [self.delegate webViewController:self didRunCommandPath:commandPath arguments:arguments directoryPath:directoryPath];
    }
}

- (void)pluginTask:(nonnull NSTask *)task didReadFromStandardError:(nonnull NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(webViewController:didReceiveStandardError:)]) {
        [self.delegate webViewController:self didReceiveStandardError:text];
    }
}

- (void)pluginTask:(nonnull NSTask *)task didReadFromStandardOutput:(nonnull NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(webViewController:didReceiveStandardOutput:)]) {
        [self.delegate webViewController:self didReceiveStandardOutput:text];
    }
}

- (NSDictionary *)environmentDictionaryForPluginTask:(NSTask *)task
{
    NSMutableDictionary *environmentDictionary;
    NSDictionary *preferencesEnvironmentDictionary = [[UserDefaultsManager standardUserDefaults] dictionaryForKey:kEnvironmentDictionaryKey];
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

    environmentDictionary[kEnvironmentVariableSplitIDKey] = self.identifier;
    
    NSWindow *window = [self.delegate windowForWebViewController:self];
    if (window) {
        // In some circumstances the window isn't visible here, but it's still
        // returning the correct `windowNumber`. This is probably just due
        // to run loop timing.
//        NSAssert([window isVisible], @"The window should be visible.");

        NSNumber *windowNumber = [NSNumber numberWithInteger:window.windowNumber];
        NSAssert(windowNumber > 0, @"The window number should be greater than zero.");
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
