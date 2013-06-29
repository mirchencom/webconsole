//
//  LoadHTMLCommand.m
//  Web Console
//
//  Created by Roben Kleene on 6/17/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "LoadHTMLCommand.h"

#import "WebWindowsController.h"
#import "WebWindowController.h"

@implementation LoadHTMLCommand

- (id)performDefaultImplementation {
	NSDictionary *argumentsDictionary = [self evaluatedArguments];

    NSString *HTML = [self directParameter];

    NSLog(@"Input HTML = %@", HTML);
    
    NSWindow *window = [argumentsDictionary objectForKey:kAppleScriptTargetKey];
    
    WebWindowController *webWindowController;
    if (window) {
        webWindowController = (WebWindowController *)window.windowController;
    } else {
        webWindowController = [[WebWindowsController sharedWebWindowsController] addedWebWindowController];
        window = webWindowController.window;
    }

    [self suspendExecution];
    [webWindowController loadHTML:HTML completionHandler:^(BOOL success) {
#warning Debug code
        WebView *webView = (WebView *)[webWindowController valueForKey:@"webView"];
        NSString *source = [(DOMHTMLElement *)[[[webView mainFrame] DOMDocument] documentElement] outerHTML];
        NSLog(@"Output Source = %@", source);

        [self resumeExecutionWithResult:window];
    }];
    
    return nil;
}

@end
