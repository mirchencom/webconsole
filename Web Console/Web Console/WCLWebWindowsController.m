//
//  WebWindowsController.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLWebWindowsController.h"

#import "WCLWebWindowController.h"
#import "WCLPlugin.h"

#define kWebWindowNibName @"WebWindow"

@interface WCLWebWindowsController ()
@property (nonatomic, strong) NSMutableArray *mutableWebWindowControllers;
@end

@interface WCLWebWindowController (WebWindowsController)
@property (nonatomic, strong) WCLPlugin *plugin;
@end

@implementation WCLWebWindowsController

+ (id)sharedWebWindowsController
{
    static dispatch_once_t pred;
    static WCLWebWindowsController *webWindowsController = nil;
    
    dispatch_once(&pred, ^{ webWindowsController = [[self alloc] init]; });
    return webWindowsController;
}

- (id)init
{
    self = [super init];
    if (self) {
        _mutableWebWindowControllers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)webWindowControllers
{
    return [self.mutableWebWindowControllers copy];
}

- (WCLWebWindowController *)addedWebWindowControllerForPlugin:(WCLPlugin *)plugin
{
    WCLWebWindowController *webWindowController = [self addedWebWindowController];
    webWindowController.plugin = plugin;
    return webWindowController;
}

- (WCLWebWindowController *)addedWebWindowController
{
    WCLWebWindowController *webWindowController = [[WCLWebWindowController alloc] initWithWindowNibName:kWebWindowNibName];

    [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    
    [self.mutableWebWindowControllers addObject:webWindowController];
    
    return webWindowController;
}

- (void)removeWebWindowController:(WCLWebWindowController *)webWindowController
{
    [self.mutableWebWindowControllers removeObject:webWindowController];
}

- (NSArray *)webWindowControllersForPlugin:(WCLPlugin *)plugin
{
    NSPredicate *pluginPredicate = [NSPredicate predicateWithFormat:@"(plugin = %@)", plugin];
    return [self.mutableWebWindowControllers filteredArrayUsingPredicate:pluginPredicate];
}

- (NSArray *)windowsForPlugin:(WCLPlugin *)plugin
{
    NSArray *pluginWebWindowControllers = [self webWindowControllersForPlugin:plugin];
    
    NSArray *pluginWindows = [pluginWebWindowControllers valueForKeyPath:@"window"];

    NSArray *applicationWindows = [[NSApplication sharedApplication] orderedWindows];
    NSMutableArray *windows = [[NSMutableArray alloc] init];
    for (NSWindow *window in applicationWindows) {
        if ([pluginWindows containsObject:window]) {
            [windows addObject:window];
        }
    }

    return windows;
}

- (NSArray *)tasks
{
    NSMutableArray *tasks = [NSMutableArray array];
    for (WCLWebWindowController *webWindowController in self.mutableWebWindowControllers) {
        [tasks addObjectsFromArray:webWindowController.tasks];
    }
    return tasks;
}

@end
