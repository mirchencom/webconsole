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

@interface WCLSplitWebWindowsController () <WCLSplitWebWindowControllerDelegate>
@property (nonatomic, strong) NSMutableArray *mutableSplitWebWindowControllers;
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

- (WCLSplitWebWindowController *)addedSplitWebWindowController
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:bundle];

    WCLSplitWebWindowController *splitWebWindowController = [storyboard instantiateControllerWithIdentifier:@"SplitWebWindowController"];

    [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    splitWebWindowController.delegate = self;
    [self addSplitWebWindowController:splitWebWindowController];
    
    return splitWebWindowController;
}

- (NSArray *)splitWebWindowControllersForPlugin:(Plugin *)plugin
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

#pragma mark - Private

- (void)removeSplitWebWindowController:(WCLSplitWebWindowController *)splitWebWindowController
{
    [self.mutableSplitWebWindowControllers removeObject:splitWebWindowController];
}

- (void)addSplitWebWindowController:(WCLSplitWebWindowController *)splitWebWindowController
{
    [self.mutableSplitWebWindowControllers addObject:splitWebWindowController];
}


#pragma mark - WCLSplitWebWindowControllerDelegate

- (void)splitWebWindowControllerWindowWillClose:(WCLSplitWebWindowController *)splitWebWindowController
{
    [self removeSplitWebWindowController:splitWebWindowController];
}

@end
