//
//  SplitWebViewControllerTests.swift
//  Web Console
//
//  Created by Roben Kleene on 10/21/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest
@testable import Web_Console

class SplitWebViewControllerPluginDebugModeEnabledTests: WCLSplitWebWindowControllerTestCase {

    func testPluginDebugModeEnabled() {
        guard let logPlugin = PluginsManager.sharedInstance.pluginWithName(testLogPluginName) else {
            XCTAssertTrue(false)
            return
        }

        // Run `HelloWorld` because the `TestLog` Plugin requires AppleScript
        // which is blocked when running tests.
        let splitWebWindowController = makeSplitWebWindowControllerRunningHelloWorldForPlugin(logPlugin)
        let splitWebViewController = splitWebWindowController.contentViewController as! SplitWebViewController
        
        // Confirm the preference is off
        XCTAssertFalse(UserDefaultsManager
            .standardUserDefaults()
            .boolForKey(debugModeEnabledKey),
            "Debug mode should be disabled in `standardUserDefaults`")
        // Debug should be enabled, even though the preference is off
        XCTAssertTrue(splitWebViewController.shouldDebugLog)
        
        // Clean Up
        self.dynamicType.blockUntilAllTasksRunAndFinish()
    }

    func testPluginDebugModeEnabledFalse() {
        guard let printPlugin = PluginsManager.sharedInstance.pluginWithName(testPrintPluginName) else {
            XCTAssertTrue(false)
            return
        }
        
        // Run `HelloWorld` because the `Print` Plugin requires AppleScript
        // which is blocked when running tests.
        let splitWebWindowController = makeSplitWebWindowControllerRunningHelloWorldForPlugin(printPlugin)
        let splitWebViewController = splitWebWindowController.contentViewController as! SplitWebViewController
        
        // Turn on debug mode
        UserDefaultsManager.standardUserDefaults().setBool(true, forKey: debugModeEnabledKey)

        // Confirm the preference is On
        XCTAssertTrue(UserDefaultsManager
            .standardUserDefaults()
            .boolForKey(debugModeEnabledKey))
        // Debug should be disabled, even though the preference is on
        XCTAssertFalse(splitWebViewController.shouldDebugLog)
        
        // Clean Up
        self.dynamicType.blockUntilAllTasksRunAndFinish()
    }
    
}

class SplitWebViewControllerDebugModeToggleTests: WCLSplitWebWindowControllerTestCase {

    func testToggleDebugMode() {

        let splitWebWindowController = makeSplitWebWindowController()
        let splitWebViewController = splitWebWindowController.contentViewController as! SplitWebViewController
        
        // Confirm that `shouldDebugLog` matches the preference
        XCTAssertFalse(UserDefaultsManager.standardUserDefaults().boolForKey(debugModeEnabledKey))
        XCTAssertFalse(splitWebViewController.shouldDebugLog)

        // Toggle
        UserDefaultsManager.standardUserDefaults().setBool(true, forKey: debugModeEnabledKey)
        XCTAssertTrue(UserDefaultsManager.standardUserDefaults().boolForKey(debugModeEnabledKey))
        XCTAssertTrue(splitWebViewController.shouldDebugLog)

        // Toggle Again
        UserDefaultsManager.standardUserDefaults().setBool(false, forKey: debugModeEnabledKey)
        XCTAssertFalse(UserDefaultsManager.standardUserDefaults().boolForKey(debugModeEnabledKey))
        XCTAssertFalse(splitWebViewController.shouldDebugLog)
        
        // Clean Up
        self.dynamicType.blockUntilAllTasksRunAndFinish()
    }
}


class SplitWebViewControllerLogTests: WebViewControllerEventRouterTestCase {
    
    override func tearDown() {
        if splitWebViewController.defaultWebViewController.tasks.count > 0 {
            let pluginTask = splitWebViewController.defaultWebViewController.tasks[0]
            WCLTaskTestsHelper.blockUntilTaskFinishes(pluginTask)
        }

        super.tearDown()
    }

    func testInvalidCommandPath() {
        
        let logRunExpectation = expectationWithDescription("For running the log plugin")
        webViewControllerEventRouter.addDidRunCommandPathHandlers { (commandPath, arguments, directoryPath) -> Void in
            logRunExpectation.fulfill()
        }
        
        let logReadFromStandardInputExpectation = expectationWithDescription("For error message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectation.fulfill()
        }
        
        let pluginRunExpectation = expectationWithDescription("Plugin run")
        let plugin = PluginsManager.sharedInstance.pluginWithName(testInvalidPluginName)!
        splitWebWindowController.runPlugin(plugin, withArguments: nil, inDirectoryPath: nil) { (success) -> Void in
            pluginRunExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }
    
    func testDebugLog() {

        let logRunExpectation = expectationWithDescription("For running the log plugin")
        webViewControllerEventRouter.addDidRunCommandPathHandlers { (commandPath, arguments, directoryPath) -> Void in
            logRunExpectation.fulfill()
        }

        let logReadFromStandardInputExpectation = expectationWithDescription("For start running log message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectation.fulfill()
        }

        let logReadFromStandardInputExpectationTwo = expectationWithDescription("For finished running log message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationTwo.fulfill()
        }

        let logReadFromStandardInputExpectationThree = expectationWithDescription("For the plugins output")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationThree.fulfill()
        }

        let pluginRunExpectation = expectationWithDescription("Plugin run")
        let plugin = PluginsManager.sharedInstance.pluginWithName(testHelloWorldPluginName)!
        splitWebWindowController.runPlugin(plugin, withArguments: nil, inDirectoryPath: nil) { (success) -> Void in
            pluginRunExpectation.fulfill()
        }

        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }

    func testDebugLogReadFromStandardInput() {
        let logRunExpectation = expectationWithDescription("For running the log plugin")
        webViewControllerEventRouter.addDidRunCommandPathHandlers { (commandPath, arguments, directoryPath) -> Void in
            logRunExpectation.fulfill()
        }
        
        let logReadFromStandardInputExpectation = expectationWithDescription("For start running log message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectation.fulfill()
        }
        
        
        let logReadFromStandardInputExpectationThree = expectationWithDescription("For the plugins output")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationThree.fulfill()
        }

        let logReadFromStandardInputExpectationFour = expectationWithDescription("For logging reading for standard input")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationFour.fulfill()
        }
        
        let pluginRunExpectation = expectationWithDescription("Plugin run")
        let plugin = PluginsManager.sharedInstance.pluginWithName(testCatPluginName)!
        splitWebWindowController.runPlugin(plugin, withArguments: nil, inDirectoryPath: nil) { (success) -> Void in
            self.splitWebWindowController.readFromStandardInput("Testing read from standard input")
            pluginRunExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(testTimeout, handler: nil)

        
        // Clean up
        let logReadFromStandardInputExpectationTwo = expectationWithDescription("For finished running log message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationTwo.fulfill()
        }
        
        let pluginTask = splitWebViewController.defaultWebViewController.tasks[0]
        let terminatePluginTaskExpectation = expectationWithDescription("Terminate plugin task")
        WCLTaskHelper.terminateTask(pluginTask) { (success) -> Void in
            XCTAssertTrue(success)
            terminatePluginTaskExpectation.fulfill()
        }

        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }
    
    func testDebugModeOff() {
        // Turn off debug mode
        UserDefaultsManager.standardUserDefaults().setBool(false, forKey: debugModeEnabledKey)
        XCTAssertFalse(splitWebViewController.shouldDebugLog)

        let pluginRunExpectation = expectationWithDescription("Plugin run")
        let plugin = PluginsManager.sharedInstance.pluginWithName(testHelloWorldPluginName)!
        splitWebWindowController.runPlugin(plugin, withArguments: nil, inDirectoryPath: nil) { (success) -> Void in
            pluginRunExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }
    
}
