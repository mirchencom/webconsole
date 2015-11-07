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

        let logRunExpectation = expectationWithDescription("For running the log plugin")
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
        let printPluginTask = splitWebViewController.defaultWebViewController.tasks[0]
        
        let terminatePluginTaskExpectation = expectationWithDescription("Terminate plugin task")
        WCLTaskHelper.terminateTask(printPluginTask) { (success) -> Void in
            XCTAssertTrue(success)
            terminatePluginTaskExpectation.fulfill()
        }

        waitForExpectationsWithTimeout(testTimeout, handler: nil)

        XCTAssertEqual(splitWebWindowController.tasks().count, 1)
        XCTAssertTrue(splitWebViewController.defaultWebViewController.tasks.count == 0)        
    }

}