//
//  WebWindowController.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WebWindowController.h"

#import "WebWindowsController.h"

@interface WebWindowController () <NSWindowDelegate>
@property (weak) IBOutlet WebView *webView;
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

- (void)loadHTML:(NSString *)HTML {    
    [self.webView.mainFrame loadHTMLString:HTML baseURL:nil];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    
    NSLog(@"windowDidLoad");

}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification {
    [[WebWindowsController sharedWebWindowsController] removeWebWindowController:self];
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
    NSURL *URL = [request URL];
    if ([[URL scheme] isEqualToString:@"file"]) {
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    } else {
        [listener use];
    }
}

- (void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener {
    NSLog(@"type = %@", type);
    
    [listener use];
}


@end
