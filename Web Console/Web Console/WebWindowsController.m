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
@property (nonatomic, strong) NSMutableArray *mutableWebWindowControllers;
@end

@interface WebWindowController (WebWindowsController)
@property (nonatomic, strong) Plugin *plugin;
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
        _mutableWebWindowControllers = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)webWindowControllers
{
    return [self.mutableWebWindowControllers copy];
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
    
    [self.mutableWebWindowControllers addObject:webWindowController];
    
    return webWindowController;
}

- (void)removeWebWindowController:(WebWindowController *)webWindowController
{
    [self.mutableWebWindowControllers removeObject:webWindowController];
}

- (NSArray *)webWindowControllersForPlugin:(Plugin *)plugin
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
    for (WebWindowController *webWindowController in self.mutableWebWindowControllers) {
        [tasks addObjectsFromArray:webWindowController.tasks];
    }
    return tasks;
}

@end
