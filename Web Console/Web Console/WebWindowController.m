//
//  WebWindowController.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WebWindowController.h"

@interface WebWindowController ()
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
    
    
    NSLog(@"Got here");
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
