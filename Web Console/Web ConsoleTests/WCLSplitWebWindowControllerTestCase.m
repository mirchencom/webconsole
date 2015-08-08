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
    (void)[self webWindowControllerRunningCommandPath:commandPath task:&task];
    return task;
}

+ (WCLSplitWebWindowController *)webWindowControllerRunningCommandPath:(NSString *)commandPath
{
    return [self webWindowControllerRunningCommandPath:commandPath task:nil];
}

+ (WCLSplitWebWindowController *)webWindowControllerRunningCommandPath:(NSString *)commandPath task:(NSTask **)task
{
    Plugin *plugin = [[PluginsManager sharedInstance] pluginWithName:kTestPrintPluginName];
    [plugin runCommandPath:commandPath withArguments:nil inDirectoryPath:nil];
    
    NSArray *webWindowControllers = [[WCLSplitWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    NSAssert([webWindowControllers count], @"The WCLPlugin should have a WCLSplitWebWindowController.");

    // The last web window controller should be the newest created and therefore have the task we're looking for
    WCLSplitWebWindowController *webWindowController = webWindowControllers.lastObject;
    NSAssert([webWindowController hasTasks], @"The WCLSplitWebWindowController should have an NSTask.");

    if (task) {
        *task = webWindowController.tasks[0];
    }

    [WCLTaskTestsHelper blockUntilTaskIsRunning:webWindowController.tasks[0]];

    return webWindowController;
}

@end
