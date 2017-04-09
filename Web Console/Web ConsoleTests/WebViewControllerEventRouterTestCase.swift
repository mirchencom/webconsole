//
//  WebViewControllerEventRouter.swift
//  Web Console
//
//  Created by Roben Kleene on 11/1/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

@testable import Web_Console



// MARK: WebViewControllerEventRouter

class WebViewControllerEventRouter: NSObject {

    typealias DidReadFromStandardInputHandler = (_ text: String) -> Void
    typealias DidRunCommandPathHandler = (_ commandPath: String,
        _ arguments: [String]?,
        _ directoryPath: String?) -> Void
    var didReadFromStandardInputHandlers: [DidReadFromStandardInputHandler]
    var didRunCommandPathHandlers: [DidRunCommandPathHandler]

    weak var delegate: WCLWebViewControllerDelegate!
    
    override init() {
        self.didReadFromStandardInputHandlers = [DidReadFromStandardInputHandler]()
        self.didRunCommandPathHandlers = [DidRunCommandPathHandler]()
    }
    
    func addDidReadFromStandardInputHandler(handler: @escaping DidReadFromStandardInputHandler) {
        didReadFromStandardInputHandlers.append(handler)
    }

    func addDidRunCommandPathHandlers(handler: @escaping DidRunCommandPathHandler) {
        didRunCommandPathHandlers.append(handler)
    }
    
}

extension WebViewControllerEventRouter: WCLWebViewControllerDelegate {
    
    // MARK: Handled
    
    func webViewController(_ webViewController: WCLWebViewController,
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

        let handler = didRunCommandPathHandlers.remove(at: 0)
        handler(commandPath, arguments, directoryPath)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, didReadFromStandardInput text: String) {
        
        self.delegate.webViewController?(webViewController, didReadFromStandardInput: text)

        if didReadFromStandardInputHandlers.count < 1 {
            XCTAssertTrue(false, "There should be at least one handler")
        }
        
        let handler = didReadFromStandardInputHandlers.remove(at: 0)
        handler(text)
    }
    
    // MARK: Forwarded
    
    func window(for webViewController: WCLWebViewController) -> NSWindow {
        return self.delegate.window(for: webViewController)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, didFinish task: Process) {
        self.delegate.webViewController?(webViewController, didFinish: task)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, didReceiveStandardError text: String) {
        self.delegate.webViewController?(webViewController, didReceiveStandardError: text)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, didReceiveStandardOutput text: String) {
        self.delegate.webViewController?(webViewController, didReceiveStandardOutput: text)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, willStart task: Process) {
        self.delegate.webViewController?(webViewController, willStart: task)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, didReceiveTitle title: String) {
        self.delegate.webViewController?(webViewController, didReceiveTitle: title)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, willDoJavaScript javaScript: String) {
        self.delegate.webViewController?(webViewController, willDoJavaScript: javaScript)
    }

}

// MARK: WebViewControllerEventRouterTestCase

class WebViewControllerEventRouterTestCase: WCLSplitWebWindowControllerTestCase {
    var webViewControllerEventRouter: WebViewControllerEventRouter!
    var splitWebWindowController: WCLSplitWebWindowController!
    var splitWebViewController: SplitWebViewController!
    
    override func setUp() {
        super.setUp()
        
        splitWebWindowController = WCLSplitWebWindowsController
            .shared()
            .addedSplitWebWindowController()
        splitWebViewController = splitWebWindowController
            .contentViewController as! SplitWebViewController
        
        // Swap delegates
        webViewControllerEventRouter = WebViewControllerEventRouter()
        webViewControllerEventRouter.delegate = splitWebViewController.defaultWebViewController.delegate
        splitWebViewController.defaultWebViewController.delegate = webViewControllerEventRouter    
    }
    
    override func tearDown() {
        // Revert the delegates
        splitWebViewController.defaultWebViewController.delegate = webViewControllerEventRouter.delegate
        webViewControllerEventRouter.delegate = nil
        webViewControllerEventRouter = nil
        
        splitWebWindowController = nil
        splitWebViewController = nil

        super.tearDown()
    }

    
    
}

    
