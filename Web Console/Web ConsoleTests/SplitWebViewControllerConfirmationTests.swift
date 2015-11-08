//
//  SplitWebViewControllerTasksRequiringConfirmationTests.swift
//  Web Console
//
//  Created by Roben Kleene on 11/7/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation
import XCTest
@testable import Web_Console

class SplitWebViewControllerConfirmationTests: WebViewControllerEventRouterTestCase {

    func testTasksRequiringConfirmation() {
        startPluginAndLogTasks()

        terminatePluginTask()
    }
    
    func startPluginAndLogTasks() {
        let logReadFromStandardInputExpectation = expectationWithDescription("Start running plugin log message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectation.fulfill()
        }
        
        let logRunExpectation = expectationWithDescription("Running log plugin")
        webViewControllerEventRouter.addDidRunCommandPathHandlers { (commandPath, arguments, directoryPath) -> Void in
            logRunExpectation.fulfill()
        }
        
        let pluginRunExpectation = expectationWithDescription("Plugin run")
        let plugin = PluginsManager.sharedInstance.pluginWithName(testPrintPluginName)!
        splitWebWindowController.runPlugin(plugin, withArguments: nil, inDirectoryPath: nil) { (success) -> Void in
            pluginRunExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        XCTAssertEqual(splitWebWindowController.tasks().count, 2)
        XCTAssertTrue(splitWebViewController.defaultWebViewController.tasks.count > 0)
    }
    
    func terminatePluginTask() {
        let pluginTerminateReadFromStandardInputExpectationOne = expectationWithDescription("Terminate plugin log message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            pluginTerminateReadFromStandardInputExpectationOne.fulfill()
        }

        // Terminating the task results in two error messages
        let pluginTerminateReadFromStandardInputExpectationTwo = expectationWithDescription("Terminate plugin log message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            pluginTerminateReadFromStandardInputExpectationTwo.fulfill()
        }
        
        let pluginFinishedReadFromStandardInputExpectation = expectationWithDescription("Finished running plugin log message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            pluginFinishedReadFromStandardInputExpectation.fulfill()
        }

        let pluginTask = splitWebViewController.defaultWebViewController.tasks[0]
        let terminatePluginTaskExpectation = expectationWithDescription("Terminate plugin task")
        WCLTaskHelper.terminateTask(pluginTask) { (success) -> Void in
            XCTAssertTrue(success)
            terminatePluginTaskExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        
        XCTAssertEqual(splitWebWindowController.tasks().count, 1)
        XCTAssertTrue(splitWebViewController.defaultWebViewController.tasks.count == 0)
    }

}