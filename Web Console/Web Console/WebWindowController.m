//
//  WebWindowController.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WebWindowController.h"

#import "WebWindowsController.h"

#import "NSTask+Termination.h"

#import "UserInterfaceTextHelper.h"

@interface WebWindowController () <NSWindowDelegate>
@property (weak) IBOutlet WebView *webView;
@property (nonatomic, strong) void (^completionHandler)(BOOL success);
@end

@implementation WebWindowController

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
    [self showWindow:self]; // If showWindow is not before loadHTMLString, then failure completion handler will not fire.

    [self.webView.mainFrame loadHTMLString:HTML baseURL:baseURL];
    
    self.completionHandler = completionHandler;
}

- (NSString *)doJavaScript:(NSString *)javaScript {
    return [self.webView stringByEvaluatingJavaScriptFromString:javaScript];
}

#pragma mark - NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender {
    if ([self.tasks count]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"Close"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"Do you want to close this window?"];
        
        NSString *informativeText = [UserInterfaceTextHelper closeWindowWithTasksInformativeTextForTasks:self.tasks];
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
    [[WebWindowsController sharedWebWindowsController] removeWebWindowController:self];
}

#pragma mark - modalDelegate

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode != NSAlertFirstButtonReturn) return;
    
    for (NSTask *task in self.tasks) {
        [task interruptWithCompletionHandler:^(BOOL success) {
            if (!success) {
#warning Terminate here
            } else {
                if (![self.tasks count]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.window close];
                    });
                }
            }        
        }];
    }
}

#pragma mark - WebPolicyDelegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
    NSURL *URL = [request URL];
    if ([[URL scheme] isEqualToString:@"file"]) {
        switch ([actionInformation[@"WebActionNavigationTypeKey"] intValue]) {
            case WebNavigationTypeLinkClicked:
                [[NSWorkspace sharedWorkspace] openURL:[request URL]];
                break;
            default:
                [listener use];
                break;
        }
    } else {
        [listener use];
    }
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

- (NSArray *)tasks {
    if (_tasks) return _tasks;    
    _tasks = [NSMutableArray array];
    return _tasks;
}

@end
