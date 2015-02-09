//
//  WCLWebWindowControllerTestCase.m
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLWebWindowControllerTestCase.h"

#import "WCLWebWindowControllerTestsHelper.h"
#import "WCLTaskTestsHelper.h"
#import "Web_Console-Swift.h"

@implementation WCLWebWindowControllerTestCase

- (void)tearDown
{
    [WCLWebWindowControllerTestsHelper closeWindowsAndBlockUntilFinished];
    
    [super tearDown];
}

#pragma mark - Running Tasks

+ (NSTask *)taskRunningCommandPath:(NSString *)commandPath
{
    NSTask *task;
    (void)[self webWindowControllerRunningCommandPath:commandPath task:&task];
    return task;
}

+ (WCLWebWindowController *)webWindowControllerRunningCommandPath:(NSString *)commandPath
{
    return [self webWindowControllerRunningCommandPath:commandPath task:nil];
}

+ (WCLWebWindowController *)webWindowControllerRunningCommandPath:(NSString *)commandPath task:(NSTask **)task
{
    Plugin *plugin = [[PluginsManager sharedInstance] pluginWithName:kTestPrintPluginName];
    [plugin runCommandPath:commandPath withArguments:nil inDirectoryPath:nil];

    NSArray *webWindowControllers = [[WCLWebWindowsController sharedWebWindowsController] webWindowControllersForPlugin:plugin];
    NSAssert([webWindowControllers count], @"The WCLPlugin should have a WCLWebWindowController.");
    WCLWebWindowController *webWindowController = webWindowControllers[0];
    NSAssert([webWindowController hasTasks], @"The WCLWebWindowController should have an NSTask.");

    if (task) {
        *task = webWindowController.tasks[0];
    }

    [WCLTaskTestsHelper blockUntilTaskIsRunning:webWindowController.tasks[0]];

    return webWindowController;
}

@end
