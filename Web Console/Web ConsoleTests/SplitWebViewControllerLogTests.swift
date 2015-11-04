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
        let catPlugin = PluginsManager.sharedInstance.pluginWithName(testCatPluginName)!
        splitWebWindowController = makeSplitWebWindowControllerForPlugin(catPlugin)
        splitWebViewController = splitWebWindowController.contentViewController as! SplitWebViewController

        // Swap the `splitWebViewControllerEventRouter` for the `splitWebViewController`'s delegate
        splitWebViewControllerEventRouter = SplitWebViewControllerEventRouter()
        splitWebViewControllerEventRouter.delegate = splitWebViewController.delegate
        splitWebViewController.delegate = splitWebViewControllerEventRouter

        // Swap the `webViewControllerEventRouter` for the `logWebViewController`'s delegate
        webViewControllerEventRouter = WebViewControllerEventRouter()
        webViewControllerEventRouter.delegate = splitWebViewController.logWebViewController.delegate
        splitWebViewController.logWebViewController.delegate = webViewControllerEventRouter
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
        
        splitWebWindowController = nil
        let expectation = expectationWithDescription("Terminate tasks")
        WCLTaskHelper.terminateTasks(splitWebWindowController.tasks()) { (success) -> Void in
            XCTAssert(success)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        super.tearDown()
    }
    
    // TODO: Test the `TestLog` plugin with debug on
    // TODO: Test the `TestLog` plugin with debug off
    // TODO: Run a normal plugin, and test the `logDebugMessage()` and `logDebugError()`, with debug on
    // TODO: Run a normal plugin, and test the `logDebugMessage()` and `logDebugError()`, with debug off
    
//    func testLogPluginWithDebugOn() {
//        UserDefaultsManager.standardUserDefaults().setBool(true, forKey: "WCLDebugModeEnabled")
//        //userDefaultsDictionary[kDebugModeEnabledKey] = @NO;
//        
//        var text = testLogPluginInfoMessage
//        splitWebViewController.logDebugMessage(text)
//        
//        // Block until the message is logged here, probably by adding an intermediary event handler?
//        let firstLogMessage = logSplit.doJavaScript(firstParagraphJavaScript)
//        XCTAssertEqual(firstLogMessage, text)
//
//        text = testLogPluginErrorMessage
//        splitWebViewController.logDebugError(text)
//        let lastLogMessage = logSplit.doJavaScript(lastParagraphJavaScript)
//        XCTAssertEqual(lastLogMessage, testLogPluginErrorMessage)
//    }
}
