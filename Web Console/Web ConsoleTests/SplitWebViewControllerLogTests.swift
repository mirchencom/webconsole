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


class SplitWebViewControllerLogTests: WCLSplitWebWindowControllerTestCase {

    var webViewControllerEventRouter: WebViewControllerEventRouter!
    var splitWebViewControllerEventRouter: SplitWebViewControllerEventRouter!
    var splitWebWindowController: WCLSplitWebWindowController!
    var splitWebViewController: SplitWebViewController!
    
    override func setUp() {
        super.setUp()

        // The setup:
        // 1. The `splitWebViewController`'s main split will run the default plugin
        // 2. The `splitWebViewController`'s `logWebViewController` will run the `testCatPluginName`
        // 3. Events for the `logWebViewController` can be managed through the `webViewControllerEventRouter`

        splitWebWindowController = WCLSplitWebWindowsController.sharedSplitWebWindowsController().addedSplitWebWindowController()
        splitWebViewController = splitWebWindowController.contentViewController as! SplitWebViewController

        // Swap the `splitWebViewControllerEventRouter` for the `splitWebViewController`'s delegate
        splitWebViewControllerEventRouter = SplitWebViewControllerEventRouter()
        splitWebViewControllerEventRouter.delegate = splitWebViewController.delegate
        splitWebViewController.delegate = splitWebViewControllerEventRouter

        // Swap the `webViewControllerEventRouter` for the `logWebViewController`'s delegate
        webViewControllerEventRouter = WebViewControllerEventRouter()
        webViewControllerEventRouter.delegate = splitWebViewController.logWebViewController.delegate
        splitWebViewController.logWebViewController.delegate = webViewControllerEventRouter

        // Turn on debug mode
        UserDefaultsManager.standardUserDefaults().setBool(true, forKey: debugModeEnabledKey)
        XCTAssertTrue(splitWebViewController.shouldDebugLog)
    }
    
    override func tearDown() {
        // Revert the `webViewControllerEventRouter` as the `logWebViewController`'s delegate
        splitWebViewController.logWebViewController.delegate = webViewControllerEventRouter.delegate
        webViewControllerEventRouter.delegate = nil
        webViewControllerEventRouter = nil
        
        // Revert the `splitWebViewControllerEventRouter` as the `splitWebViewController`'s delegate
        splitWebViewController.delegate = splitWebViewControllerEventRouter.delegate
        splitWebViewController.delegate = nil
        splitWebViewController = nil
        
        let expectation = expectationWithDescription("Terminate tasks")
        WCLTaskHelper.terminateTasks(splitWebWindowController.tasks()) { (success) -> Void in
            XCTAssert(success)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        splitWebWindowController = nil
        super.tearDown()
    }
    
    func testDebugLog() {

        let logRunExpectation = expectationWithDescription("For running the log plugin")
        webViewControllerEventRouter.addDidRunCommandPathHandlers { (commandPath, arguments, directoryPath) -> Void in
            logRunExpectation.fulfill()
        }

        // One read from standard input expectation for plugin starting to run
        let logReadFromStandardInputExpectation = expectationWithDescription("For start running log message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectation.fulfill()
        }

        // Another for plugin finishing running
        let logReadFromStandardInputExpectationTwo = expectationWithDescription("For finished running log message")
        webViewControllerEventRouter.addDidReadFromStandardInputHandler { (text) -> Void in
            logReadFromStandardInputExpectationTwo.fulfill()
        }

        // Another for plugin finishing running
        let logReadFromStandardInputExpectationThree = expectationWithDescription("For log plugins output")
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
    
}
