//
//  WebViewControllerEventRouter.swift
//  Web Console
//
//  Created by Roben Kleene on 11/1/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

@testable import Web_Console

class SplitWebViewControllerEventRouter: NSObject, SplitWebViewControllerDelegate {
    weak var delegate: SplitWebViewControllerDelegate!
    
    init(delegate: SplitWebViewControllerDelegate) {
        self.delegate = delegate
    }

    // MARK: SplitWebViewControllerDelegate Handled
    
    func logPluginForSplitWebViewController(splitWebViewController: SplitWebViewController) -> Plugin? {
        return PluginsManager.sharedInstance.pluginWithName(testCatPluginName)!
    }
    
    // MARK: SplitWebViewControllerDelegate Forwarded
    
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

class WebViewControllerEventRouter: NSObject, WCLWebViewControllerDelegate {
    weak var delegate: WCLWebViewControllerDelegate!
    
    init(delegate: WCLWebViewControllerDelegate) {
        self.delegate = delegate
    }


    // MARK: WCLWebViewControllerDelegate Handled
    
    func webViewController(webViewController: WCLWebViewController,
        didRunCommandPath commandPath: String,
        arguments: [String]?,
        directoryPath: String?)
    {

    }
    
    func webViewController(webViewController: WCLWebViewController, didReadFromStandardInput text: String) {
        self.delegate.webViewController?(webViewController, didReadFromStandardInput: text)
    }


    // MARK: WCLWebViewControllerDelegate Forwarded
    
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

//class PluginDataEventManager: PluginsDataControllerDelegate {
//    var pluginWasAddedHandlers: Array<(plugin: Plugin) -> Void>
//    var pluginWasRemovedHandlers: Array<(plugin: Plugin) -> Void>
//    var delegate: PluginsDataControllerDelegate?
//
//    init () {
//        self.pluginWasAddedHandlers = Array<(plugin: Plugin) -> Void>()
//        self.pluginWasRemovedHandlers = Array<(plugin: Plugin) -> Void>()
//    }
//
//
//    // MARK: PluginsDataControllerDelegate
//
//    func pluginsDataController(pluginsDataController: PluginsDataController, didAddPlugin plugin: Plugin) {
//        delegate?.pluginsDataController(pluginsDataController, didAddPlugin: plugin)
//
//        assert(pluginWasAddedHandlers.count > 0, "There should be at least one handler")
//
//        if (pluginWasAddedHandlers.count > 0) {
//            let handler = pluginWasAddedHandlers.removeAtIndex(0)
//            handler(plugin: plugin)
//        }
//    }
//
//    func pluginsDataController(pluginsDataController: PluginsDataController, didRemovePlugin plugin: Plugin) {
//        delegate?.pluginsDataController(pluginsDataController, didRemovePlugin: plugin)
//
//        assert(pluginWasRemovedHandlers.count > 0, "There should be at least one handler")
//
//        if (pluginWasRemovedHandlers.count > 0) {
//            let handler = pluginWasRemovedHandlers.removeAtIndex(0)
//            handler(plugin: plugin)
//        }
//    }
//
//    // MARK: Handlers
//
//    func addPluginWasAddedHandler(handler: (plugin: Plugin) -> Void) {
//        pluginWasAddedHandlers.append(handler)
//    }
//
//    func addPluginWasRemovedHandler(handler: (plugin: Plugin) -> Void) {
//        pluginWasRemovedHandlers.append(handler)
//    }
//
//}