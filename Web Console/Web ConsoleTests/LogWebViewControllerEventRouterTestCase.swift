//
//  LogWebViewControllerEventRouterTestCase.swift
//  Web Console
//
//  Created by Roben Kleene on 1/12/16.
//  Copyright © 2016 Roben Kleene. All rights reserved.
//

@testable import Web_Console

// MARK: SplitWebWindowControllerEventRouter

class LogSplitWebWindowControllerEventRouter: NSObject {
    weak var delegate: WCLSplitWebWindowControllerDelegate!
}

extension LogSplitWebWindowControllerEventRouter: WCLSplitWebWindowControllerDelegate {
    
    // MARK: Handled
    
    func logPlugin(for splitWebViewController: WCLSplitWebWindowController) -> Plugin? {
        return PluginsManager.sharedInstance.plugin(for: testPrintPluginName)!
    }
    
    // MARK: Forwarded
    
    func splitWebWindowControllerWindowWillClose(splitWebWindowController: WCLSplitWebWindowController) {
        self.delegate.splitWebWindowControllerWindowWillClose?(splitWebWindowController)
    }
}

// MARK: LogWebViewControllerEventRouterTestCase

class LogWebViewControllerEventRouterTestCase: WCLSplitWebWindowControllerTestCase {
    
    var logWebViewControllerEventRouter: WebViewControllerEventRouter!
    var logSplitWebWindowControllerEventRouter: LogSplitWebWindowControllerEventRouter!
    var splitWebWindowController: WCLSplitWebWindowController!
    var splitWebViewController: SplitWebViewController!
    
    override func setUp() {
        super.setUp()
        
        // The setup:
        // 1. The `splitWebViewController`'s main split will not be running a plugin yet
        // 2. The `splitWebViewController`'s `logWebViewController` will run the `testCatPluginName`
        // 3. Events for the `logWebViewController` can be managed through the `webViewControllerEventRouter`
        
        splitWebWindowController = WCLSplitWebWindowsController
            .shared()
            .addedSplitWebWindowController()
        splitWebViewController = splitWebWindowController
            .contentViewController as! SplitWebViewController
        
        // Swap the `splitWebViewControllerEventRouter` for the `splitWebViewController`'s delegate
        logSplitWebWindowControllerEventRouter = LogSplitWebWindowControllerEventRouter()
        logSplitWebWindowControllerEventRouter.delegate = splitWebWindowController.delegate
        splitWebWindowController.delegate = logSplitWebWindowControllerEventRouter
        
        // Swap the `webViewControllerEventRouter` for the `logWebViewController`'s delegate
        logWebViewControllerEventRouter = WebViewControllerEventRouter()
        logWebViewControllerEventRouter.delegate = splitWebViewController.logWebViewController.delegate
        splitWebViewController.logWebViewController.delegate = logWebViewControllerEventRouter
        
        // Turn on debug mode
        XCTAssertFalse(splitWebViewController.shouldDebugLog)
        UserDefaultsManager.standardUserDefaults().set(true, forKey: debugModeEnabledKey)
        XCTAssertTrue(splitWebViewController.shouldDebugLog)
    }
    
    override func tearDown() {
        UserDefaultsManager.standardUserDefaults().set(false, forKey: debugModeEnabledKey)
        
        // `tearDown` must be called after returning off debugging because the superclass disabled
        // the user defaults mock
        // `tearDown` must be called before removing the `webViewControllerEventRouter` and
        // `splitWebWindowControllerEventRouter` because this preserves the status
        // of the `logPlugin` while the superclass closes the window.
        // (E.g., the `logPlugin`'s `launchPath` should not be listed in the
        // `commandsRequiringConfirmation`)
        super.tearDown()
        
        // Revert the `webViewControllerEventRouter` as the `logWebViewController`'s delegate
        splitWebViewController.logWebViewController.delegate = logWebViewControllerEventRouter.delegate
        logWebViewControllerEventRouter.delegate = nil
        logWebViewControllerEventRouter = nil
        
        // Revert the `splitWebViewControllerEventRouter` as the `splitWebViewController`'s delegate
        splitWebWindowController.delegate = logSplitWebWindowControllerEventRouter.delegate
        splitWebWindowController.delegate = nil
        splitWebWindowController = nil
        
        splitWebViewController = nil
    }
    
}
