//
//  WebWindowsController.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WebWindowsController.h"

#import "WebWindowController.h"
#import "Plugin.h"

#define kWebWindowNibName @"WebWindow"

@interface WebWindowsController ()
@property (nonatomic, strong) NSMutableArray *webWindowControllers;
@end

@implementation WebWindowsController

+ (id)sharedWebWindowsController
{
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

- (WebWindowController *)addedWebWindowControllerForPlugin:(Plugin *)plugin
{
    WebWindowController *webWindowController = [self addedWebWindowController];
    webWindowController.plugin = plugin;
    return webWindowController;
}

- (WebWindowController *)addedWebWindowController
{
    WebWindowController *webWindowController = [[WebWindowController alloc] initWithWindowNibName:kWebWindowNibName];

    [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    
    [self.webWindowControllers addObject:webWindowController];
    
    return webWindowController;
}

- (void)removeWebWindowController:(WebWindowController *)webWindowController
{
    [self.webWindowControllers removeObject:webWindowController];
}

- (NSArray *)windowsForPlugin:(Plugin *)plugin
{
    NSPredicate *pluginPredicate = [NSPredicate predicateWithFormat:@"(plugin = %@)", plugin];
    NSArray *pluginWebWindowControllers = [self.webWindowControllers filteredArrayUsingPredicate:pluginPredicate];
    NSArray *pluginWindows = [pluginWebWindowControllers valueForKeyPath:@"window"];

    NSArray *applicationWindows = [[NSApplication sharedApplication] orderedWindows];
    NSMutableArray *windows = [[NSMutableArray alloc] init];
    for (NSWindow *window in applicationWindows) {
        if ([pluginWindows containsObject:window]) {
            [windows addObject:window];
        }
    }
    
    NSLog(@"windows = %@", windows);
    
    return windows;
}

@end
