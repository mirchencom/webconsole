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
        guard let logPlugin = PluginsManager.sharedInstance.plugin(forName: testLogPluginName) else {
            XCTAssertTrue(false)
            return
        }

        // Run `HelloWorld` because the `TestLog` Plugin requires AppleScript
        // which is blocked when running tests.
        let splitWebWindowController = makeSplitWebWindowControllerRunningHelloWorld(for: logPlugin)
        let splitWebViewController = splitWebWindowController.contentViewController as! SplitWebViewController
        
        // Confirm the preference is off
        XCTAssertFalse(UserDefaultsManager
            .standardUserDefaults()
            .bool(forKey: debugModeEnabledKey),
            "Debug mode should be disabled in `standardUserDefaults`")
        // Debug should be enabled, even though the preference is off
        XCTAssertTrue(splitWebViewController.shouldDebugLog)
        
        // Clean Up
        type(of: self).blockUntilAllTasksRunAndFinish()
    }

    func testPluginDebugModeEnabledFalse() {
        guard let printPlugin = PluginsManager.sharedInstance.plugin(forName: testPrintPluginName) else {
            XCTAssertTrue(false)
            return
        }
        
        // Run `HelloWorld` because the `Print` Plugin requires AppleScript
        // which is blocked when running tests.
        let splitWebWindowController = makeSplitWebWindowControllerRunningHelloWorld(for: printPlugin)
        let splitWebViewController = splitWebWindowController.contentViewController as! SplitWebViewController
        
        // Turn on debug mode
        UserDefaultsManager.standardUserDefaults().set(true, forKey: debugModeEnabledKey)

        // Confirm the preference is On
        XCTAssertTrue(UserDefaultsManager
            .standardUserDefaults()
            .bool(forKey: debugModeEnabledKey))
        // Debug should be disabled, even though the preference is on
        XCTAssertFalse(splitWebViewController.shouldDebugLog)
        
        // Clean Up
        type(of: self).blockUntilAllTasksRunAndFinish()
    }
    
}

class SplitWebViewControllerDebugModeToggleTests: WCLSplitWebWindowControllerTestCase {

    func testToggleDebugMode() {

        let splitWebWindowController = makeSplitWebWindowController()
        let splitWebViewController = splitWebWindowController.contentViewController as! SplitWebViewController
        
        // Confirm that `shouldDebugLog` matches the preference
        XCTAssertFalse(UserDefaultsManager.standardUserDefaults().bool(forKey: debugModeEnabledKey))
        XCTAssertFalse(splitWebViewController.shouldDebugLog)

        // Toggle
        UserDefaultsManager.standardUserDefaults().set(true, forKey: debugModeEnabledKey)
        XCTAssertTrue(UserDefaultsManager.standardUserDefaults().bool(forKey: debugModeEnabledKey))
        XCTAssertTrue(splitWebViewController.shouldDebugLog)

        // Toggle Again
        UserDefaultsManager.standardUserDefaults().set(false, forKey: debugModeEnabledKey)
        XCTAssertFalse(UserDefaultsManager.standardUserDefaults().bool(forKey: debugModeEnabledKey))
        XCTAssertFalse(splitWebViewController.shouldDebugLog)
        
        // Clean Up
        type(of: self).blockUntilAllTasksRunAndFinish()
    }
}


class SplitWebViewControllerLogTests: LogWebViewControllerEventRouterTestCase {
    
    override func tearDown() {
        if splitWebViewController.defaultWebViewController.tasks.count > 0 {
            let pluginTask = splitWebViewController.defaultWebViewController.tasks[0]
            WCLTaskTestsHelper.block(untilTaskFinishes: pluginTask)
        }

        super.tearDown()
    }

    func testInvalidCommandPath() {
        
        let logRunExpectation = expectation(description: "For running the log plugin")
        logWebViewControllerEventRouter.addDidRunCommandPathHandlers { (commandPath, arguments, directoryPath) -> Void in
            logRunExpectation.fulfill()
        }
        
        let logReadFromStandardInputExpectation = expectation(description: "For error message")
        logWebViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectation.fulfill()
        }
        
        let pluginRunExpectation = expectation(description: "Plugin run")
        let plugin = PluginsManager.sharedInstance.plugin(forName: testInvalidPluginName)!
        splitWebWindowController.runPlugin(plugin, withArguments: nil, inDirectoryPath: nil) { (success) -> Void in
            pluginRunExpectation.fulfill()
        }
        
        waitForExpectations(timeout: testTimeout, handler: nil)
    }
    
    func testDebugLog() {

        let logRunExpectation = expectation(description: "For running the log plugin")
        logWebViewControllerEventRouter.addDidRunCommandPathHandlers { (commandPath, arguments, directoryPath) -> Void in
            logRunExpectation.fulfill()
        }

        let logReadFromStandardInputExpectation = expectation(description: "For start running log message")
        logWebViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectation.fulfill()
        }

        let logReadFromStandardInputExpectationTwo = expectation(description: "For finished running log message")
        logWebViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationTwo.fulfill()
        }

        let logReadFromStandardInputExpectationThree = expectation(description: "For the plugins output")
        logWebViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationThree.fulfill()
        }

        let pluginRunExpectation = expectation(description: "Plugin run")
        let plugin = PluginsManager.sharedInstance.plugin(forName: testHelloWorldPluginName)!
        splitWebWindowController.runPlugin(plugin, withArguments: nil, inDirectoryPath: nil) { (success) -> Void in
            pluginRunExpectation.fulfill()
        }

        waitForExpectations(timeout: testTimeout, handler: nil)
    }

    func testDebugLogReadFromStandardInput() {
        let logRunExpectation = expectation(description: "For running the log plugin")
        logWebViewControllerEventRouter.addDidRunCommandPathHandlers { (commandPath, arguments, directoryPath) -> Void in
            logRunExpectation.fulfill()
        }
        
        let logReadFromStandardInputExpectation = expectation(description: "For start running log message")
        logWebViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectation.fulfill()
        }
        
        
        let logReadFromStandardInputExpectationThree = expectation(description: "For the plugins output")
        logWebViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationThree.fulfill()
        }

        let logReadFromStandardInputExpectationFour = expectation(description: "For logging reading for standard input")
        logWebViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationFour.fulfill()
        }
        
        let pluginRunExpectation = expectation(description: "Plugin run")
        let plugin = PluginsManager.sharedInstance.plugin(forName: testCatPluginName)!
        splitWebWindowController.runPlugin(plugin, withArguments: nil, inDirectoryPath: nil) { (success) -> Void in
            self.splitWebWindowController.read(fromStandardInput: "Testing read from standard input")
            pluginRunExpectation.fulfill()
        }
        
        waitForExpectations(timeout: testTimeout, handler: nil)

        
        // Clean up
        let logReadFromStandardInputExpectationTwo = expectation(description: "For finished running log message")
        logWebViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationTwo.fulfill()
        }
        
        let pluginTask = splitWebViewController.defaultWebViewController.tasks[0]
        let terminatePluginTaskExpectation = expectation(description: "Terminate plugin task")
        WCLTaskHelper.terminateTask(pluginTask) { (success) -> Void in
            XCTAssertTrue(success)
            terminatePluginTaskExpectation.fulfill()
        }

        waitForExpectations(timeout: testTimeout, handler: nil)
    }
    
    func testDebugModeOff() {
        // Turn off debug mode
        UserDefaultsManager.standardUserDefaults().set(false, forKey: debugModeEnabledKey)
        XCTAssertFalse(splitWebViewController.shouldDebugLog)

        let pluginRunExpectation = expectation(description: "Plugin run")
        let plugin = PluginsManager.sharedInstance.plugin(forName: testHelloWorldPluginName)!
        splitWebWindowController.runPlugin(plugin, withArguments: nil, inDirectoryPath: nil) { (success) -> Void in
            pluginRunExpectation.fulfill()
        }
        waitForExpectations(timeout: testTimeout, handler: nil)
    }
    
}
