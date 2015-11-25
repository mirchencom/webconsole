//
//  WebViewControllerEventRouter.swift
//  Web Console
//
//  Created by Roben Kleene on 11/1/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

@testable import Web_Console

// MARK: SplitWebWindowControllerEventRouter

class SplitWebWindowControllerEventRouter: NSObject {
    weak var delegate: WCLSplitWebWindowControllerDelegate!
}

extension SplitWebWindowControllerEventRouter: WCLSplitWebWindowControllerDelegate {

    // MARK: Handled
    
    func logPluginForSplitWebWindowController(splitWebViewController: WCLSplitWebWindowController) -> Plugin? {
        return PluginsManager.sharedInstance.pluginWithName(testPrintPluginName)!
    }

    // MARK: Forwarded
    
    func splitWebWindowControllerWindowWillClose(splitWebWindowController: WCLSplitWebWindowController) {
        self.delegate.splitWebWindowControllerWindowWillClose?(splitWebWindowController)
    }
}

// MARK: WebViewControllerEventRouter

class WebViewControllerEventRouter: NSObject {

    typealias DidReadFromStandardInputHandler = (text: String) -> Void
    typealias DidRunCommandPathHandler = (commandPath: String,
        arguments: [String]?,
        directoryPath: String?) -> Void
    var didReadFromStandardInputHandlers: [DidReadFromStandardInputHandler]
    var didRunCommandPathHandlers: [DidRunCommandPathHandler]

    weak var delegate: WCLWebViewControllerDelegate!
    
    override init() {
        self.didReadFromStandardInputHandlers = [DidReadFromStandardInputHandler]()
        self.didRunCommandPathHandlers = [DidRunCommandPathHandler]()
    }
    
    func addDidReadFromStandardInputHandler(handler: DidReadFromStandardInputHandler) {
        didReadFromStandardInputHandlers.append(handler)
    }

    func addDidRunCommandPathHandlers(handler: DidRunCommandPathHandler) {
        didRunCommandPathHandlers.append(handler)
    }
    
}

extension WebViewControllerEventRouter: WCLWebViewControllerDelegate {
    
    // MARK: Handled
    
    func webViewController(webViewController: WCLWebViewController,
        didRunCommandPath commandPath: String,
        arguments: [String]?,
        directoryPath: String?)
    {
        self.delegate.webViewController?(webViewController,
            didRunCommandPath: commandPath,
            arguments: arguments,
            directoryPath: directoryPath)
        
        if didRunCommandPathHandlers.count < 1 {
            XCTAssertTrue(false, "There should be at least one handler")
        }

        let handler = didRunCommandPathHandlers.removeAtIndex(0)
        handler(commandPath: commandPath, arguments: arguments, directoryPath: directoryPath)
    }
    
    func webViewController(webViewController: WCLWebViewController, didReadFromStandardInput text: String) {
        
        self.delegate.webViewController?(webViewController, didReadFromStandardInput: text)

        if didReadFromStandardInputHandlers.count < 1 {
            XCTAssertTrue(false, "There should be at least one handler")
        }
        
        let handler = didReadFromStandardInputHandlers.removeAtIndex(0)
        handler(text: text)
    }
    
    // MARK: Forwarded
    
    func windowForWebViewController(webViewController: WCLWebViewController) -> NSWindow {
        return self.delegate.windowForWebViewController(webViewController)
    }
    
    func webViewController(webViewController: WCLWebViewController, didFinishTask task: NSTask) {
        self.delegate.webViewController?(webViewController, didFinishTask: task)
    }
    
    func webViewController(webViewController: WCLWebViewController, didReceiveStandardError text: String) {
        self.delegate.webViewController?(webViewController, didReceiveStandardError: text)
    }
    
    func webViewController(webViewController: WCLWebViewController, didReceiveStandardOutput text: String) {
        self.delegate.webViewController?(webViewController, didReceiveStandardOutput: text)
    }
    
    func webViewController(webViewController: WCLWebViewController, willStartTask task: NSTask) {
        self.delegate.webViewController?(webViewController, willStartTask: task)
    }
    
    func webViewController(webViewController: WCLWebViewController, didReceiveTitle title: String) {
        self.delegate.webViewController?(webViewController, didReceiveTitle: title)
    }
    
    func webViewController(webViewController: WCLWebViewController, willDoJavaScript javaScript: String) {
        self.delegate.webViewController?(webViewController, willDoJavaScript: javaScript)
    }

}

// MARK: WebViewControllerEventRouterTestCase

class WebViewControllerEventRouterTestCase: WCLSplitWebWindowControllerTestCase {

    var webViewControllerEventRouter: WebViewControllerEventRouter!
    var splitWebWindowControllerEventRouter: SplitWebWindowControllerEventRouter!
    var splitWebWindowController: WCLSplitWebWindowController!
    var splitWebViewController: SplitWebViewController!
    
    override func setUp() {
        super.setUp()
        
        // The setup:
        // 1. The `splitWebViewController`'s main split will not be running a plugin yet
        // 2. The `splitWebViewController`'s `logWebViewController` will run the `testCatPluginName`
        // 3. Events for the `logWebViewController` can be managed through the `webViewControllerEventRouter`
        
        splitWebWindowController = WCLSplitWebWindowsController.sharedSplitWebWindowsController().addedSplitWebWindowController()
        splitWebViewController = splitWebWindowController.contentViewController as! SplitWebViewController
        
        // Swap the `splitWebViewControllerEventRouter` for the `splitWebViewController`'s delegate
        splitWebWindowControllerEventRouter = SplitWebWindowControllerEventRouter()
        splitWebWindowControllerEventRouter.delegate = splitWebWindowController.delegate
        splitWebWindowController.delegate = splitWebWindowControllerEventRouter
        
        // Swap the `webViewControllerEventRouter` for the `logWebViewController`'s delegate
        webViewControllerEventRouter = WebViewControllerEventRouter()
        webViewControllerEventRouter.delegate = splitWebViewController.logWebViewController.delegate
        splitWebViewController.logWebViewController.delegate = webViewControllerEventRouter

        // Turn on debug mode
        XCTAssertFalse(splitWebViewController.shouldDebugLog)
        UserDefaultsManager.standardUserDefaults().setBool(true, forKey: debugModeEnabledKey)
        XCTAssertTrue(splitWebViewController.shouldDebugLog)
    }

    override func tearDown() {
        UserDefaultsManager.standardUserDefaults().setBool(false, forKey: debugModeEnabledKey)
        XCTAssertFalse(splitWebViewController.shouldDebugLog)
        
        // `tearDown` must be called after returning off debugging because the superclass disabled
        // the user defaults mock
        // `tearDown` must be called before removing the `webViewControllerEventRouter` and 
        // `splitWebWindowControllerEventRouter` because this preserves the status
        // of the `logPlugin` while the superclass closes the window.
        // (E.g., the `logPlugin`'s `launchPath` should not be listed in the
        // `commandsRequiringConfirmation`)
        super.tearDown()
        
        // Revert the `webViewControllerEventRouter` as the `logWebViewController`'s delegate
        splitWebViewController.logWebViewController.delegate = webViewControllerEventRouter.delegate
        webViewControllerEventRouter.delegate = nil
        webViewControllerEventRouter = nil
        
        // Revert the `splitWebViewControllerEventRouter` as the `splitWebViewController`'s delegate
        splitWebWindowController.delegate = splitWebWindowControllerEventRouter.delegate
        splitWebWindowController.delegate = nil
        splitWebWindowController = nil
        
        splitWebViewController = nil
    }

}