//
//  WCLSplitWebWindowControllerTestCase.m
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLSplitWebWindowControllerTestCase.h"

#import "WCLSplitWebWindowControllerTestsHelper.h"
#import "WCLTaskTestsHelper.h"
#import "Web_Console-Swift.h"

@implementation WCLSplitWebWindowControllerTestCase

- (void)tearDown
{
    [WCLSplitWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    [super tearDown];
}

#pragma mark - Running Tasks

+ (NSTask *)taskRunningCommandPath:(NSString *)commandPath
{
    NSTask *task;
    (void)[self splitWebWindowControllerRunningCommandPath:commandPath task:&task];
    return task;
}

+ (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath
{
    return [self splitWebWindowControllerRunningCommandPath:commandPath task:nil];
}

+ (WCLSplitWebWindowController *)splitWebWindowControllerRunningCommandPath:(NSString *)commandPath task:(NSTask **)task
{
    Plugin *plugin = [[PluginsManager sharedInstance] pluginWithName:kTestPrintPluginName];
    [plugin runCommandPath:commandPath withArguments:nil inDirectoryPath:nil];
    
    NSArray *splitWebWindowControllers = [[WCLSplitWebWindowsController sharedSplitWebWindowsController] splitWebWindowControllersForPlugin:plugin];
    NSAssert([splitWebWindowControllers count], @"The WCLPlugin should have a WCLSplitWebWindowController.");

    // The last web window controller should be the newest created and therefore have the task we're looking for
    WCLSplitWebWindowController *splitWebWindowController = splitWebWindowControllers.lastObject;
    NSAssert([splitWebWindowController hasTasks], @"The WCLSplitWebWindowController should have an NSTask.");

    if (task) {
        *task = splitWebWindowController.tasks[0];
    }

    [WCLTaskTestsHelper blockUntilTaskIsRunning:splitWebWindowController.tasks[0]];

    return splitWebWindowController;
}

@end
