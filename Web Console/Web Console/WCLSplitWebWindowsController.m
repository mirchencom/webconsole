//
//  WebWindowsController.m
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLSplitWebWindowsController.h"

#import "WCLSplitWebWindowController.h"
#import "WCLPlugin.h"

#define kWebWindowNibName @"WebWindow"

@interface WCLSplitWebWindowsController ()
@property (nonatomic, strong) NSMutableArray *mutableWebWindowControllers;
@end

@interface WCLSplitWebWindowController (WebWindowsController)
@property (nonatomic, strong) WCLPlugin *plugin;
@end

@implementation WCLSplitWebWindowsController

+ (instancetype)sharedWebWindowsController
{
    static dispatch_once_t pred;
    static WCLSplitWebWindowsController *webWindowsController = nil;
    
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

- (WCLSplitWebWindowController *)addedWebWindowControllerForPlugin:(Plugin *)plugin
{
    WCLSplitWebWindowController *webWindowController = [self addedWebWindowController];
    webWindowController.plugin = plugin;
    return webWindowController;
}

- (WCLSplitWebWindowController *)addedWebWindowController
{
    WCLSplitWebWindowController *webWindowController = [[WCLSplitWebWindowController alloc] initWithWindowNibName:kWebWindowNibName];

    [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    
    [self.mutableWebWindowControllers addObject:webWindowController];
    
    return webWindowController;
}

- (void)removeWebWindowController:(WCLSplitWebWindowController *)webWindowController
{
    [self.mutableWebWindowControllers removeObject:webWindowController];
}

- (NSArray *)webWindowControllersForPlugin:(WCLPlugin *)plugin
{
    NSPredicate *pluginPredicate = [NSPredicate predicateWithFormat:@"(plugin = %@)", plugin];
    return [self.mutableWebWindowControllers filteredArrayUsingPredicate:pluginPredicate];
}

- (NSArray *)windowsForPlugin:(Plugin *)plugin
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
    for (WCLSplitWebWindowController *webWindowController in self.mutableWebWindowControllers) {
        [tasks addObjectsFromArray:webWindowController.tasks];
    }
    return tasks;
}

@end
