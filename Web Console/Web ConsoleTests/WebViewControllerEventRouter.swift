//
//  WebViewControllerEventRouter.swift
//  Web Console
//
//  Created by Roben Kleene on 11/1/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

@testable import Web_Console

// MARK: SplitWebViewControllerEventRouter

class SplitWebViewControllerEventRouter: NSObject {
    weak var delegate: SplitWebViewControllerDelegate!
}

extension SplitWebViewControllerEventRouter: SplitWebViewControllerDelegate {

    // MARK: Handled
    
    func logPluginForSplitWebViewController(splitWebViewController: SplitWebViewController) -> Plugin? {
        return PluginsManager.sharedInstance.pluginWithName(testCatPluginName)!
    }
    
    // MARK: Forwarded
    
    func windowIsVisibleForSplitWebViewController(splitWebViewController: SplitWebViewController) -> Bool {
        return self.delegate.windowIsVisibleForSplitWebViewController(splitWebViewController)
    }
    
    func windowForSplitWebViewController(splitWebViewController: SplitWebViewController) -> NSWindow! {
        return self.delegate.windowForSplitWebViewController(splitWebViewController)
    }
    
    func splitWebViewController(splitWebViewController: SplitWebViewController, didReceiveTitle title: String) {
        return self.delegate.splitWebViewController(splitWebViewController, didReceiveTitle: title)
    }
    
    func splitWebViewControllerWillLoadHTML(splitWebViewController: SplitWebViewController) {
        self.delegate.splitWebViewControllerWillLoadHTML(splitWebViewController)
    }
    
    func splitWebViewController(splitWebViewController: SplitWebViewController, willStartTask task: NSTask) {
        self.delegate.splitWebViewController(splitWebViewController, willStartTask: task)
    }
    
    func splitWebViewController(splitWebViewController: SplitWebViewController, didFinishTask task: NSTask) {
        return self.delegate.splitWebViewController(splitWebViewController, didFinishTask: task)
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