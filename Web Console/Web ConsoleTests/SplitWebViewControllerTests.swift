//
//  SplitViewPrototypeTests.swift
//  SplitViewPrototypeTests
//
//  Created by Roben Kleene on 7/19/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
import XCTest



class SplitWebViewControllerTests: WCLSplitWebWindowControllerTestCase {
    
    var savedFrameName: String {
        let plugin = self.dynamicType.defaultPlugin()
        return SplitWebViewController.savedFrameNameForPluginName(plugin.name)
    }
    
    override func setUp() {
        super.setUp()
        NSUserDefaults.standardUserDefaults().removeObjectForKey(savedFrameName)
    }
    
    override func tearDown() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(savedFrameName)
        super.tearDown()
    }
    
    func testSplitWebViewController() {
        
        let splitWebViewController = makeNewSplitWebViewController()
        
        // The log starts collapsed
        XCTAssertTrue(splitWebViewController.logController.logSplitViewItem.collapsed, "The  NSSplitViewItem should be collapsed")
        
        // Show the log
        makeLogAppearForSplitWebViewController(splitWebViewController)
        XCTAssertEqual(heightForSplitWebViewController(splitWebViewController), splitWebViewHeight, "The heights should be equal")
        
        // Resize the log
        resizeLogForSplitWebViewController(splitWebViewController, logHeight: testLogViewHeight)
        
        // Close and re-show the log
        makeLogDisappearForSplitWebViewController(splitWebViewController)
        
        // Reshow the log
        makeLogAppearForSplitWebViewController(splitWebViewController)
        
        // Test that the frame height was restored
        XCTAssertEqual(heightForSplitWebViewController(splitWebViewController), testLogViewHeight, "The heights should be equal")


        // Make a second window and confirm it uses the saved height
        let secondSplitWebViewController = makeNewSplitWebViewController()
        XCTAssertTrue(secondSplitWebViewController.logController.logSplitViewItem.collapsed, "The  NSSplitViewItem should be collapsed")
        makeLogAppearForSplitWebViewController(secondSplitWebViewController)
        XCTAssertEqual(heightForSplitWebViewController(secondSplitWebViewController), testLogViewHeight, "The heights should be equal")

        // Close the log in the first window
        makeLogDisappearForSplitWebViewController(splitWebViewController)
        
        // Wait for the new frame to be saved
        resizeLogForSplitWebViewController(secondSplitWebViewController, logHeight: splitWebViewHeight)
        
        // Re-open the log in the first window and confirm it has the right height
        makeLogAppearForSplitWebViewController(splitWebViewController)
        XCTAssertEqual(heightForSplitWebViewController(splitWebViewController), splitWebViewHeight, "The heights should be equal")
    }
    
    // MARK: Helpers
    
    func resizeLogForSplitWebViewController(splitWebViewController: SplitWebViewController, logHeight: CGFloat) {
        // Resize & Wait for Save

        let name = splitWebViewController.savedFrameNameForLogController(splitWebViewController.logController)!
        makeFrameSaveExpectationForHeight(logHeight, name: name)
        splitWebViewController.logController.configureHeight(logHeight)
        waitForExpectationsWithTimeout(testTimeout, handler: nil)

        // Test the height & saved frame
        XCTAssertEqual(heightForSplitWebViewController(splitWebViewController), logHeight, "The heights should be equal")
        var frame: NSRect! = splitWebViewController.logController.savedLogSplitViewFrame()
        XCTAssertEqual(frame.size.height, logHeight, "The heights should be equal")
    }
    
    func makeLogAppearForSplitWebViewController(splitWebViewController: SplitWebViewController) {
        makeLogViewWillAppearExpectationForSplitWebViewController(splitWebViewController)
        splitWebViewController.toggleLogShown(nil)
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        XCTAssertFalse(splitWebViewController.logController.logSplitViewItem.collapsed, "The  NSSplitViewItem should not be collapsed")
        confirmValuesForSplitWebViewController(splitWebViewController, collapsed: false)
    }
    
    func makeLogDisappearForSplitWebViewController(splitWebViewController: SplitWebViewController) {
        makeLogViewWillDisappearExpectationForSplitWebViewController(splitWebViewController)
        splitWebViewController.toggleLogShown(nil)
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        XCTAssertTrue(splitWebViewController.logController.logSplitViewItem.collapsed, "The  NSSplitViewItem should be collapsed")
        confirmValuesForSplitWebViewController(splitWebViewController, collapsed: true)
    }

    func confirmValuesForSplitWebViewController(splitWebViewController: SplitWebViewController, collapsed: Bool) {
        let logIndex: Int! = find(splitWebViewController.splitViewItems as! [NSSplitViewItem], splitWebViewController.logController.logSplitViewItem)
        XCTAssertNotNil(logIndex, "The index should not be nil")
        
        var result = splitWebViewController.splitView(splitWebViewController.splitView, canCollapseSubview: splitWebViewController.logController.logSplitViewSubview!)
        XCTAssertTrue(result, "The log NSView should be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, canCollapseSubview: NSView())
        XCTAssertFalse(result , "The NSView should not be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldCollapseSubview: splitWebViewController.logController.logSplitViewSubview!, forDoubleClickOnDividerAtIndex: logIndex)
        XCTAssertTrue(result, "The log NSView should be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldCollapseSubview: NSView(), forDoubleClickOnDividerAtIndex: logIndex + 1)
        XCTAssertFalse(result , "The NSView should not be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldHideDividerAtIndex: logIndex - 1)
        XCTAssertTrue(result == collapsed, "The divider should be hidden if the log view is hidden")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldHideDividerAtIndex: logIndex)
        XCTAssertFalse(result, "The divider should never be hidden for the NSView")
    }
    
    func heightForSplitWebViewController(splitWebViewController: SplitWebViewController) -> CGFloat {
        return splitWebViewController.logController.logView!.frame.size.height
    }
    
    func makeNewSplitWebViewController() -> SplitWebViewController {
        let pluginWindowController = makeSplitWebWindowController()
        return pluginWindowController.splitWebViewController
    }
    
    func makeLogViewWillAppearExpectationForSplitWebViewController(splitWebViewController: SplitWebViewController) {
        let webViewController = splitWebViewController.logController.logSplitViewItem.viewController as! WCLWebViewController
        let viewWillAppearExpectation = expectationWithDescription("WebViewController will appear")
        let webViewControllerEventManager = WebViewControllerEventManager(webViewController: webViewController, viewWillAppearBlock: { _ in
            viewWillAppearExpectation.fulfill()
        }, viewWillDisappearBlock: nil)
    }
    
    func makeLogViewWillDisappearExpectationForSplitWebViewController(splitWebViewController: SplitWebViewController) {
        let webViewController = splitWebViewController.logController.logSplitViewItem.viewController as! WCLWebViewController
        let viewWillDisappearExpectation = expectationWithDescription("WebViewController will appear")
        let webViewControllerEventManager = WebViewControllerEventManager(webViewController: webViewController, viewWillAppearBlock: nil) { _ in
            viewWillDisappearExpectation.fulfill()
        }
    }
    
    func makeFrameSaveExpectationForHeight(height: CGFloat, name: String) {
        let expectation = expectationWithDescription("NSUserDefaults did change")
        var observer: NSObjectProtocol?
        observer = NSNotificationCenter.defaultCenter().addObserverForName(NSUserDefaultsDidChangeNotification,
            object: nil,
            queue: nil)
        { [unowned self] _ in
            let frame = LogController.savedFrameForName(name)
            if frame.size.height == height {
                expectation.fulfill()
                if let observer = observer {
                    NSNotificationCenter.defaultCenter().removeObserver(observer)
                }
                observer = nil
            }
        }
    }

}
