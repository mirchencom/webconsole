//
//  SplitViewPrototypeTests.swift
//  SplitViewPrototypeTests
//
//  Created by Roben Kleene on 7/19/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web_Console


class SplitWebViewControllerTests: WCLSplitWebWindowControllerTestCase {
    
    var defaultPluginSavedFrameName: String {
        let plugin = self.dynamicType.defaultPlugin()
        return SplitWebViewController.savedFrameNameForPluginName(plugin.name)
    }

    var otherPluginSavedFrameName: String {
        let plugin = self.dynamicType.defaultPlugin()
        return SplitWebViewController.savedFrameNameForPluginName(plugin.name)
    }

    
    override func setUp() {
        super.setUp()
        // Superclass mocks `standardUserDefaults`
        UserDefaultsManager.standardUserDefaults().removeObjectForKey(defaultPluginSavedFrameName)
        UserDefaultsManager.standardUserDefaults().removeObjectForKey(otherPluginSavedFrameName)
    }
    
    override func tearDown() {
        self.dynamicType.blockUntilAllTasksRunAndFinish()
        UserDefaultsManager.standardUserDefaults().removeObjectForKey(defaultPluginSavedFrameName)
        UserDefaultsManager.standardUserDefaults().removeObjectForKey(otherPluginSavedFrameName)
        super.tearDown()
    }
    
    func testSplitWebViewController() {
        
        let splitWebViewController = makeNewSplitWebViewController()
        
        // The log starts collapsed
        XCTAssertTrue(splitWebViewController.splitController.splitViewItem.collapsed, "The  NSSplitViewItem should be collapsed")
        XCTAssertEqual(logMenuItem().title, showLogMenuItemTitle, "The titles should be equal")
        
        // Show the log
        makeLogAppearForSplitWebViewController(splitWebViewController)
        XCTAssertEqual(logHeightForSplitWebViewController(splitWebViewController), splitWebViewHeight, "The heights should be equal")
        
        // Resize the log
        resizeLogForSplitWebViewController(splitWebViewController, logHeight: testLogViewHeight)
        
        // Close and re-show the log
        makeLogDisappearForSplitWebViewController(splitWebViewController)
        
        // Reshow the log
        makeLogAppearForSplitWebViewController(splitWebViewController)
        XCTAssertEqual(logMenuItem().title, hideLogMenuItemTitle, "The titles should be equal")
        
        // Test that the frame height was restored
        XCTAssertEqual(logHeightForSplitWebViewController(splitWebViewController), testLogViewHeight, "The heights should be equal")
        
        // Second Window
        
        // Make a second window and
        let secondSplitWebViewController = makeNewSplitWebViewController()
        XCTAssertEqual(logMenuItem().title, showLogMenuItemTitle, "The titles should be equal")
        XCTAssertTrue(secondSplitWebViewController.splitController.splitViewItem.collapsed, "The  NSSplitViewItem should be collapsed")

        // Confirm it uses the saved height
        makeLogAppearForSplitWebViewController(secondSplitWebViewController)
        XCTAssertEqual(logMenuItem().title, hideLogMenuItemTitle, "The titles should be equal")
        XCTAssertEqual(logHeightForSplitWebViewController(secondSplitWebViewController), testLogViewHeight, "The heights should be equal")
        
        // Close the log in the first window
        makeLogDisappearForSplitWebViewController(splitWebViewController)
        XCTAssertEqual(logMenuItem().title, hideLogMenuItemTitle, "The titles should be equal") // Should still be "Hide Log" because the other window is in front
        
        // Wait for the new frame to be saved
        resizeLogForSplitWebViewController(secondSplitWebViewController, logHeight: splitWebViewHeight)
        
        // Re-open the log in the first window and confirm it has the right height
        makeLogAppearForSplitWebViewController(splitWebViewController)
        XCTAssertEqual(logHeightForSplitWebViewController(splitWebViewController), splitWebViewHeight, "The heights should be equal")
        XCTAssertEqual(logMenuItem().title, hideLogMenuItemTitle, "The titles should be equal") // Should still be "Hide Log" because the other window is in front
        
        // TODO: Bring the other window to the front and assert it has the right text

        // Clean up
        // Closing logs increases test reliability because it assures all animation blocks have finished
        makeLogDisappearForSplitWebViewController(splitWebViewController)
    }

    func testSplitWebViewControllerDifferentPlugin() {
        // Make a window with the first plugin and resize the log
        let splitWebViewController = makeNewSplitWebViewController()
        makeLogAppearForSplitWebViewController(splitWebViewController)
        resizeLogForSplitWebViewController(splitWebViewController, logHeight: testLogViewHeight)

        // Make a window with the second plugin and resize the log
        let splitWebViewControllerTwo = makeNewSplitWebViewControllerForOtherPugin()
        makeLogAppearForSplitWebViewController(splitWebViewControllerTwo)
        resizeLogForSplitWebViewController(splitWebViewControllerTwo, logHeight: testLogViewHeightTwo)

        // Make a window with the first plugin again and confirm the size matches
        let splitWebViewControllerThree = makeNewSplitWebViewController()
        makeLogAppearForSplitWebViewController(splitWebViewControllerThree)
        XCTAssertEqual(logHeightForSplitWebViewController(splitWebViewControllerThree), testLogViewHeight, "The heights should be equal")

        // Clean up
        // Closing logs increases test reliability because it assures all animation blocks have finished
        makeLogDisappearForSplitWebViewController(splitWebViewController)
        makeLogDisappearForSplitWebViewController(splitWebViewControllerTwo)
        makeLogDisappearForSplitWebViewController(splitWebViewControllerThree)
    }

    
    // MARK: Menu Helpers
    
    func updateViewMenuItem() {
        viewMenuItem().submenu!.update()
    }
    
    func viewMenuItem() -> NSMenuItem {
        return NSApplication.sharedApplication().mainMenu!.itemAtIndex(4)!
    }
    
    func logMenuItem() -> NSMenuItem {
        let logMenuItem = viewMenuItem().submenu!.itemAtIndex(2)!
        return logMenuItem
    }
    
    // MARK: Resize Helpers

    func resizeLogForSplitWebViewController(splitWebViewController: SplitWebViewController, logHeight: CGFloat) {
        // Resize & Wait for Save

        let name = splitWebViewController.savedFrameNameForSplitController(splitWebViewController.splitController)!
        makeFrameSaveExpectationForHeight(logHeight, name: name)
        splitWebViewController.splitController.configureHeight(logHeight)
        waitForExpectationsWithTimeout(testTimeout, handler: nil)

        // Test the height & saved frame
        XCTAssertEqual(logHeightForSplitWebViewController(splitWebViewController), logHeight, "The heights should be equal")
        let frame: NSRect! = splitWebViewController.splitController.savedSplitsViewFrame()
        XCTAssertEqual(frame.size.height, logHeight, "The heights should be equal")
    }
    
    func makeLogAppearForSplitWebViewController(splitWebViewController: SplitWebViewController) {
        makeLogViewWillAppearExpectationForSplitWebViewController(splitWebViewController)
        splitWebViewController.toggleLogShown(nil)
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        XCTAssertFalse(splitWebViewController.splitController.splitViewItem.collapsed, "The  NSSplitViewItem should not be collapsed")
        confirmValuesForSplitWebViewController(splitWebViewController, collapsed: false)
        updateViewMenuItem()
    }
    
    func makeLogDisappearForSplitWebViewController(splitWebViewController: SplitWebViewController) {
        makeLogViewWillDisappearExpectationForSplitWebViewController(splitWebViewController)
        splitWebViewController.toggleLogShown(nil)
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        XCTAssertTrue(splitWebViewController.splitController.splitViewItem.collapsed, "The  NSSplitViewItem should be collapsed")
        confirmValuesForSplitWebViewController(splitWebViewController, collapsed: true)
        updateViewMenuItem()
    }

    func confirmValuesForSplitWebViewController(splitWebViewController: SplitWebViewController, collapsed: Bool) {
        let logIndex: Int! = splitWebViewController.splitViewItems.indexOf(splitWebViewController.splitController.splitViewItem)
        XCTAssertNotNil(logIndex, "The index should not be nil")
        
        var result = splitWebViewController.splitView(splitWebViewController.splitView, canCollapseSubview: splitWebViewController.splitController.splitViewsSubview!)
        XCTAssertTrue(result, "The log NSView should be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, canCollapseSubview: NSView())
        XCTAssertFalse(result , "The NSView should not be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldCollapseSubview: splitWebViewController.splitController.splitViewsSubview!, forDoubleClickOnDividerAtIndex: logIndex)
        XCTAssertTrue(result, "The log NSView should be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldCollapseSubview: NSView(), forDoubleClickOnDividerAtIndex: logIndex + 1)
        XCTAssertFalse(result , "The NSView should not be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldHideDividerAtIndex: logIndex - 1)
        XCTAssertTrue(result == collapsed, "The divider should be hidden if the log view is hidden")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldHideDividerAtIndex: logIndex)
        XCTAssertFalse(result, "The divider should never be hidden for the NSView")
    }
    
    func logHeightForSplitWebViewController(splitWebViewController: SplitWebViewController) -> CGFloat {
        return splitWebViewController.splitController.splitsView!.frame.size.height
    }

    func makeNewSplitWebViewControllerForOtherPugin() -> SplitWebViewController {
        let splitWebWindowController = makeSplitWebWindowControllerForOtherPlugin()
        splitWebWindowController.window?.setFrame(testFrame, display: false)
        updateViewMenuItem()
        return splitWebWindowController.splitWebViewController
    }
    
    func makeNewSplitWebViewController() -> SplitWebViewController {
        let splitWebWindowController = makeSplitWebWindowController()
        splitWebWindowController.window?.setFrame(testFrame, display: false)
        updateViewMenuItem()
        return splitWebWindowController.splitWebViewController
    }
    
    func makeLogViewWillAppearExpectationForSplitWebViewController(splitWebViewController: SplitWebViewController) {
        let webViewController = splitWebViewController.splitController.splitViewItem.viewController as! WCLWebViewController
        let viewWillAppearExpectation = expectationWithDescription("WebViewController will appear")
        let _ = WebViewControllerEventManager(webViewController: webViewController, viewWillAppearBlock: { _ in
            viewWillAppearExpectation.fulfill()
        }, viewWillDisappearBlock: nil)
    }
    
    func makeLogViewWillDisappearExpectationForSplitWebViewController(splitWebViewController: SplitWebViewController) {
        let webViewController = splitWebViewController.splitController.splitViewItem.viewController as! WCLWebViewController
        let viewWillDisappearExpectation = expectationWithDescription("WebViewController will appear")
        let _ = WebViewControllerEventManager(webViewController: webViewController, viewWillAppearBlock: nil) { _ in
            viewWillDisappearExpectation.fulfill()
        }
    }
    
    func makeFrameSaveExpectationForHeight(height: CGFloat, name: String) {
        let expectation = expectationWithDescription("UserDefaults did change")
        var observer: NSObjectProtocol?
        observer = NSNotificationCenter.defaultCenter().addObserverForName(NSUserDefaultsDidChangeNotification,
            object: nil,
            queue: nil)
        { _ in
            if let frame = SplitController.savedFrameForName(name) {
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

}
