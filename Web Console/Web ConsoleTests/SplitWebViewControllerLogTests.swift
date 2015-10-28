//
//  SplitWebViewControllerTests.swift
//  Web Console
//
//  Created by Roben Kleene on 10/21/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest
@testable import Web_Console

class SplitWebViewControllerLogTests: WCLSplitWebWindowControllerTestCase {

    var splitWebWindowController: WCLSplitWebWindowController!
    var splitWebViewController: SplitWebViewController!
    var splits: [WCLPluginView]!
    var logSplit: WCLPluginView {
        get {
            return self.splits[1]
        }
    }
    var pluginSplit: WCLPluginView {
        get {
            return self.splits[0]
        }
    }
    
    override func setUp() {
        super.setUp()
        splitWebWindowController = makeSplitWebWindowController()
        splitWebViewController = splitWebWindowController.contentViewController as! SplitWebViewController
        splits = splitWebWindowController.window!.splits()
        XCTAssertEqual(splits.count, 2, "There should be two splits")
    }
    
    override func tearDown() {
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
