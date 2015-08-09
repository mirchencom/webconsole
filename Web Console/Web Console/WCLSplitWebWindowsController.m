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
@property (nonatomic, strong) NSMutableArray *mutableSplitWebWindowControllers;
@end

@interface WCLSplitWebWindowController (WebWindowsController)
@property (nonatomic, strong) WCLPlugin *plugin;
@end

@implementation WCLSplitWebWindowsController

+ (instancetype)sharedSplitWebWindowsController
{
    static dispatch_once_t pred;
    static WCLSplitWebWindowsController *splitWebWindowsController = nil;
    
    dispatch_once(&pred, ^{ splitWebWindowsController = [[self alloc] init]; });
    return splitWebWindowsController;
}

- (id)init
{
    self = [super init];
    if (self) {
        _mutableSplitWebWindowControllers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)splitWebWindowControllers
{
    return [self.mutableSplitWebWindowControllers copy];
}

- (WCLSplitWebWindowController *)addedSplitWebWindowControllerForPlugin:(Plugin *)plugin
{
    WCLSplitWebWindowController *splitWebWindowController = [self addedSplitWebWindowController];
    splitWebWindowController.plugin = plugin;
    return splitWebWindowController;
}

- (WCLSplitWebWindowController *)addedSplitWebWindowController
{
    WCLSplitWebWindowController *splitWebWindowController = [[WCLSplitWebWindowController alloc] initWithWindowNibName:kWebWindowNibName];

    [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    
    [self.mutableSplitWebWindowControllers addObject:splitWebWindowController];
    
    return splitWebWindowController;
}

- (void)removeSplitWebWindowController:(WCLSplitWebWindowController *)splitWebWindowController
{
    [self.mutableSplitWebWindowControllers removeObject:splitWebWindowController];
}

- (NSArray *)splitWebWindowControllersForPlugin:(WCLPlugin *)plugin
{
    NSPredicate *pluginPredicate = [NSPredicate predicateWithFormat:@"(plugin = %@)", plugin];
    return [self.mutableSplitWebWindowControllers filteredArrayUsingPredicate:pluginPredicate];
}

- (NSArray *)windowsForPlugin:(Plugin *)plugin
{
    NSArray *pluginWebWindowControllers = [self splitWebWindowControllersForPlugin:plugin];
    
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
    for (WCLSplitWebWindowController *splitWebWindowController in self.mutableSplitWebWindowControllers) {
        [tasks addObjectsFromArray:splitWebWindowController.tasks];
    }
    return tasks;
}

@end
