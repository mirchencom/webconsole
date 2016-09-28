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

class SplitWebViewControllerLogConfirmationTests: LogWebViewControllerEventRouterTestCase {

    func testTasksRequiringConfirmation() {
        XCTAssertEqual(WCLApplicationTerminationHelper.splitWebWindowControllersWithTasks().count, 0)

        
        // Start Tasks
        startPluginAndLogTasks()
        XCTAssertEqual(WCLApplicationTerminationHelper.splitWebWindowControllersWithTasks().count, 1)
        XCTAssertTrue(splitWebWindowController.hasTasksRequiringConfirmation())
        XCTAssertEqual(splitWebWindowController.commandsRequiringConfirmation().count, 1)
        XCTAssertEqual(splitWebWindowController.commandsNotRequiringConfirmation().count, 1)
        // Wait for editing flag
        let editingPredicate = NSPredicate(format: "documentEdited == true")
        expectation(for: editingPredicate, evaluatedWith: splitWebWindowController.window!, handler: nil)
        waitForExpectations(timeout: testTimeout, handler: nil)
        XCTAssertTrue(splitWebWindowController.window!.isDocumentEdited)

        // Terminate Tasks
        terminatePluginTask()
        XCTAssertEqual(WCLApplicationTerminationHelper.splitWebWindowControllersWithTasks().count, 0)
        XCTAssertFalse(splitWebWindowController.hasTasksRequiringConfirmation())
        XCTAssertEqual(splitWebWindowController.commandsRequiringConfirmation().count, 0)
        XCTAssertEqual(splitWebWindowController.commandsNotRequiringConfirmation().count, 1)
        // Wait for editing flag
        let notEditingPredicate = NSPredicate(format: "documentEdited == false")
        expectation(for: notEditingPredicate, evaluatedWith: splitWebWindowController.window!, handler: nil)
        waitForExpectations(timeout: testTimeout, handler: nil)
        XCTAssertFalse(splitWebWindowController.window!.isDocumentEdited)
    }
    
    func startPluginAndLogTasks() {
        let logReadFromStandardInputExpectation = expectation(description: "Start running plugin log message")
        logWebViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectation.fulfill()
        }
        
        let logRunExpectation = expectation(description: "Running log plugin")
        logWebViewControllerEventRouter.addDidRunCommandPathHandlers { (commandPath, arguments, directoryPath) -> Void in
            logRunExpectation.fulfill()
        }
        
        let pluginRunExpectation = expectation(description: "Plugin run")
        let plugin = PluginsManager.sharedInstance.pluginWithName(testCatPluginName)!
        splitWebWindowController.runPlugin(plugin, withArguments: nil, inDirectoryPath: nil) { (success) -> Void in
            pluginRunExpectation.fulfill()
        }
        
        waitForExpectations(timeout: testTimeout, handler: nil)
        XCTAssertEqual(splitWebWindowController.tasks().count, 2)
        XCTAssertTrue(splitWebViewController.defaultWebViewController.tasks.count > 0)
    }
    
    func terminatePluginTask() {
        let pluginFinishedReadFromStandardInputExpectation = expectation(description: "Finished running plugin log message")
        logWebViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            pluginFinishedReadFromStandardInputExpectation.fulfill()
        }

        let pluginTask = splitWebViewController.defaultWebViewController.tasks[0]
        let terminatePluginTaskExpectation = expectation(description: "Terminate plugin task")
        WCLTaskHelper.terminateTask(pluginTask) { (success) -> Void in
            XCTAssertTrue(success)
            terminatePluginTaskExpectation.fulfill()
        }
        
        waitForExpectations(timeout: testTimeout, handler: nil)
        
        XCTAssertEqual(splitWebWindowController.tasks().count, 1)
        XCTAssertTrue(splitWebViewController.defaultWebViewController.tasks.count == 0)
    }

}
