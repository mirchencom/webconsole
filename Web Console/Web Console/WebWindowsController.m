//
//  WebWindowsController.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WebWindowsController.h"

#import "Web"

#define kWebWindowNibName @"WebWindow"

@interface WebWindowsController ()
@property (nonatomic, strong) NSMutableArray *webWindowControllers;

@end

@implementation WebWindowsController

+ (id)sharedWebWindowsController {
    static dispatch_once_t pred;
    static WebWindowsController *webWindowsController = nil;
    
    dispatch_once(&pred, ^{ webWindowsController = [[self alloc] init]; });
    return webWindowsController;
}

- (id)init
{
    self = [super init];
    if (self) {
        _webWindowControllers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addWebWindowWithHTML:(NSString *)HTML {
    WebWindowController *webWindowController = [[WebWindowController alloc] initWithWindowNibName:kWebWindowNibName];

    [webWindowController showWindow:self];
	[webWindowController loadHTML:HTML];
    
    [self.webWindowControllers addObject:webWindowController];
}

- (void)removeWebWindowController:(WebWindowController *)webWindowController {
    [self.webWindowControllers removeObject:webWindowController];
}

@end