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


class WebViewControllerLifeCycleEventRouter: NSObject, WCLWebViewControllerDelegate {
    typealias EventBlock = (WCLWebViewController) -> ()
    
    weak var storedDelegate: WCLWebViewControllerDelegate?
    var viewWillAppearBlock: EventBlock?
    var viewWillDisappearBlock: EventBlock?
    
    init(webViewController: WCLWebViewController,
        viewWillAppearBlock: EventBlock? = nil,
        viewWillDisappearBlock: EventBlock? = nil)
    {
        super.init()
        self.storedDelegate = webViewController.delegate
        webViewController.delegate = self
        
        
        if let viewWillAppearBlock = viewWillAppearBlock {
            self.viewWillAppearBlock = { webViewController in
                viewWillAppearBlock(webViewController)
                self.storedDelegate?.webViewControllerViewWillAppear!(webViewController)
                self.viewWillAppearBlock = nil
                self.blockFired(webViewController)
            }
        }
        
        if let viewWillDisappearBlock = viewWillDisappearBlock {
            self.viewWillDisappearBlock = { webViewController in
                viewWillDisappearBlock(webViewController)
                self.storedDelegate?.webViewControllerViewWillDisappear!(webViewController)
                self.viewWillDisappearBlock = nil
                self.blockFired(webViewController)
            }
        }
        
    }
    
    func blockFired(_ webViewController: WCLWebViewController) {
        if viewWillAppearBlock == nil && viewWillDisappearBlock == nil {
            webViewController.delegate = self.storedDelegate
        }
    }
    
    // MARK: WCLWebViewControllerDelegate
    
    @objc func webViewControllerViewWillAppear(_ webViewController: WCLWebViewController) {
        if let viewWillAppearBlock = viewWillAppearBlock {
            viewWillAppearBlock(webViewController)
        } else {
            self.storedDelegate!.webViewControllerViewWillAppear!(webViewController)
        }
    }
    
    @objc func webViewControllerViewWillDisappear(_ webViewController: WCLWebViewController) {
        if let viewWillDisappearBlock = viewWillDisappearBlock {
            viewWillDisappearBlock(webViewController)
        } else {
            self.storedDelegate!.webViewControllerViewWillDisappear!(webViewController)
        }
    }
    
    func window(for webViewController: WCLWebViewController) -> NSWindow {
        return self.storedDelegate!.window(for: webViewController)
    }
}

class SplitWebViewControllerResizingTests: WCLSplitWebWindowControllerTestCase {
    
    var defaultPluginSavedFrameName: String {
        let plugin = type(of: self).defaultPlugin()
        return SplitWebViewController.savedFrameNameForPluginName(plugin.name)
    }

    var otherPluginSavedFrameName: String {
        let plugin = type(of: self).defaultPlugin()
        return SplitWebViewController.savedFrameNameForPluginName(plugin.name)
    }

    
    override func setUp() {
        super.setUp()
        // Superclass mocks `standardUserDefaults`
        UserDefaultsManager.standardUserDefaults().removeObject(forKey: defaultPluginSavedFrameName)
        UserDefaultsManager.standardUserDefaults().removeObject(forKey: otherPluginSavedFrameName)
    }
    
    override func tearDown() {
        type(of: self).blockUntilAllTasksRunAndFinish()
        UserDefaultsManager.standardUserDefaults().removeObject(forKey: defaultPluginSavedFrameName)
        UserDefaultsManager.standardUserDefaults().removeObject(forKey: otherPluginSavedFrameName)
        super.tearDown()
    }
    
    func testSplitWebViewController() {
        
        let splitWebViewController = makeNewSplitWebViewController()
        
        // The log starts collapsed
        XCTAssertTrue(splitWebViewController.splitController.splitViewItem.isCollapsed, "The  NSSplitViewItem should be collapsed")
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
        XCTAssertTrue(secondSplitWebViewController.splitController.splitViewItem.isCollapsed, "The  NSSplitViewItem should be collapsed")

        // Confirm it uses the saved height
        makeLogAppearForSplitWebViewController(secondSplitWebViewController)
        XCTAssertEqual(logMenuItem().title, hideLogMenuItemTitle, "The titles should be equal")
        XCTAssertEqual(logHeightForSplitWebViewController(secondSplitWebViewController), testLogViewHeight, "The heights should be equal")
        
        // Close the log in the first window
        makeLogDisappearForSplitWebViewController(splitWebViewController)
        XCTAssertEqual(logMenuItem().title, hideLogMenuItemTitle, "The titles should be equal") // Should still be "Hide Log" because the other window is in front
        
        // Switch the order of the windows and make sure the menu item text updates
        let windows = NSApplication.shared().windows.filter { $0.windowController?.contentViewController == splitWebViewController }
        windows[0].makeKeyAndOrderFront(nil)
        updateViewMenuItem()
        XCTAssertEqual(logMenuItem().title, showLogMenuItemTitle, "The titles should be equal")

        // Wait for the new frame to be saved
        resizeLogForSplitWebViewController(secondSplitWebViewController, logHeight: splitWebViewHeight)
        
        // Re-open the log in the first window and confirm it has the right height
        makeLogAppearForSplitWebViewController(splitWebViewController)
        XCTAssertEqual(logHeightForSplitWebViewController(splitWebViewController), splitWebViewHeight, "The heights should be equal")
        XCTAssertEqual(logMenuItem().title, hideLogMenuItemTitle, "The titles should be equal")
        
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
        return NSApplication.shared().mainMenu!.item(at: 4)!
    }
    
    func logMenuItem() -> NSMenuItem {
        let logMenuItem = viewMenuItem().submenu!.item(at: 2)!
        return logMenuItem
    }
    
    // MARK: Resize Helpers

    func resizeLogForSplitWebViewController(_ splitWebViewController: SplitWebViewController, logHeight: CGFloat) {
        // Resize & Wait for Save

        let name = splitWebViewController.savedFrameNameForSplitController(splitWebViewController.splitController)!
        makeFrameSaveExpectationForHeight(logHeight, name: name)
        splitWebViewController.splitController.configureHeight(logHeight)
        
        // Simple hack to get the divider notification to fire
        // As of iOS 10, just setting the dividers position via a constraint 
        // doesn't cause the `splitViewDidResizeSubviews(_:)` delegate message 
        // to fire which triggers saving the frame. Just calling 
        // `setPosition(_:ofDividerAt:)` with any position causes this delegate
        // message to fire.
        splitWebViewController.splitView.setPosition(0, ofDividerAt: 0)
        
        waitForExpectations(timeout: testTimeout, handler: nil)

        // Test the height & saved frame
        XCTAssertEqual(logHeightForSplitWebViewController(splitWebViewController), logHeight, "The heights should be equal")
        let frame = splitWebViewController.splitController.savedSplitsViewFrame()!
        XCTAssertEqual(frame.size.height, logHeight, "The heights should be equal")
    }
    
    func makeLogAppearForSplitWebViewController(_ splitWebViewController: SplitWebViewController) {
        makeLogViewWillAppearExpectationForSplitWebViewController(splitWebViewController)
        splitWebViewController.toggleLogShown(nil)
        waitForExpectations(timeout: testTimeout, handler: nil)
        XCTAssertFalse(splitWebViewController.splitController.splitViewItem.isCollapsed, "The  NSSplitViewItem should not be collapsed")
        confirmValuesForSplitWebViewController(splitWebViewController, collapsed: false)
        updateViewMenuItem()
    }
    
    func makeLogDisappearForSplitWebViewController(_ splitWebViewController: SplitWebViewController) {
        makeLogViewWillDisappearExpectationForSplitWebViewController(splitWebViewController)
        splitWebViewController.toggleLogShown(nil)
        waitForExpectations(timeout: testTimeout, handler: nil)
        XCTAssertTrue(splitWebViewController.splitController.splitViewItem.isCollapsed, "The  NSSplitViewItem should be collapsed")
        confirmValuesForSplitWebViewController(splitWebViewController, collapsed: true)
        updateViewMenuItem()
    }

    func confirmValuesForSplitWebViewController(_ splitWebViewController: SplitWebViewController, collapsed: Bool) {
        let logIndex: Int! = splitWebViewController.splitViewItems.index(of: splitWebViewController.splitController.splitViewItem)
        XCTAssertNotNil(logIndex, "The index should not be nil")
        
        var result = splitWebViewController.splitView(splitWebViewController.splitView, canCollapseSubview: splitWebViewController.splitController.splitViewsSubview!)
        XCTAssertTrue(result, "The log NSView should be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, canCollapseSubview: NSView())
        XCTAssertFalse(result , "The NSView should not be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldCollapseSubview: splitWebViewController.splitController.splitViewsSubview!, forDoubleClickOnDividerAt: logIndex)
        XCTAssertTrue(result, "The log NSView should be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldCollapseSubview: NSView(), forDoubleClickOnDividerAt: logIndex + 1)
        XCTAssertFalse(result , "The NSView should not be collapsable")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldHideDividerAt: logIndex - 1)
        XCTAssertTrue(result == collapsed, "The divider should be hidden if the log view is hidden")
        result = splitWebViewController.splitView(splitWebViewController.splitView, shouldHideDividerAt: logIndex)
        XCTAssertFalse(result, "The divider should never be hidden for the NSView")
    }
    
    func logHeightForSplitWebViewController(_ splitWebViewController: SplitWebViewController) -> CGFloat {
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
    
    func makeLogViewWillAppearExpectationForSplitWebViewController(_ splitWebViewController: SplitWebViewController) {
        let webViewController = splitWebViewController.splitController.splitViewItem.viewController as! WCLWebViewController
        let viewWillAppearExpectation = expectation(description: "WebViewController will appear")
        _ = WebViewControllerLifeCycleEventRouter(webViewController: webViewController, viewWillAppearBlock: { _ in
            viewWillAppearExpectation.fulfill()
        }, viewWillDisappearBlock: nil)
    }
    
    func makeLogViewWillDisappearExpectationForSplitWebViewController(_ splitWebViewController: SplitWebViewController) {
        let webViewController = splitWebViewController.splitController.splitViewItem.viewController as! WCLWebViewController
        let viewWillDisappearExpectation = expectation(description: "WebViewController will appear")
        _ = WebViewControllerLifeCycleEventRouter(webViewController: webViewController, viewWillAppearBlock: nil) { _ in
            viewWillDisappearExpectation.fulfill()
        }
    }
    
    func makeFrameSaveExpectationForHeight(_ height: CGFloat, name: String) {
        let expectation = self.expectation(description: "UserDefaults did change")
        var observer: NSObjectProtocol?
        observer = NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: nil)
        { _ in
            if let frame = SplitController.savedFrameForName(name) {
                if frame.size.height == height {
                    expectation.fulfill()
                    if let observer = observer {
                        NotificationCenter.default.removeObserver(observer)
                    }
                    observer = nil
                }
            }
        }
    }

}
