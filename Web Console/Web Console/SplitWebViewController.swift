//
//  WebSplitViewController.swift
//  Web Console
//
//  Created by Roben Kleene on 7/19/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
import WebKit
import AppKit

let splitWebViewHeight = CGFloat(150)

@objc protocol SplitWebViewControllerDelegate: class {
    func windowIsVisibleForSplitWebViewController(splitWebViewController: SplitWebViewController) -> Bool
    func windowForSplitWebViewController(splitWebViewController: SplitWebViewController) -> NSWindow!
    func splitWebViewController(splitWebViewController: SplitWebViewController, didReceiveTitle title: String)
    func splitWebViewControllerWillLoadHTML(splitWebViewController: SplitWebViewController)
    func splitWebViewControllerWillStartTasks(splitWebViewController: SplitWebViewController)
    func splitWebViewControllerDidFinishTasks(splitWebViewController: SplitWebViewController)
    func logPluginForSplitWebViewController(splitWebViewController: SplitWebViewController) -> Plugin?
}

class SplitWebViewController: NSSplitViewController, WCLWebViewControllerDelegate, SplitControllerDelegate {

    // MARK: Properties
    
    weak var delegate: SplitWebViewControllerDelegate?
    var splitController: SplitController!

    var splitViewItemDividerIndex: Int? {
        if let index = splitController.splitViewItemIndex {
            return index - 1
        }
        return nil
    }
    
    var defaultWebViewController: WCLWebViewController {
        let splitViewItem = splitViewItems.first as! NSSplitViewItem
        return splitViewItem.viewController as! WCLWebViewController
    }
    
    var plugin: Plugin? {
        return defaultWebViewController.plugin
    }
    
    var webViewControllers: [WCLWebViewController] {
        return splitViewItems.map { $0.viewController as! WCLWebViewController }
    }
    
    // MARK: Log
    
    var shouldLog: Bool {
        // TODO: This should check the plugins debug flag
#if DEBUG
        return true
#else
        return false
#endif
    }
    
    var logSplitViewItem: NSSplitViewItem {
        return splitViewItems.last as! NSSplitViewItem
    }

    var logWebViewController: WCLWebViewController {
        let splitViewItem = splitViewItems.last as! NSSplitViewItem
        return splitViewItem.viewController as! WCLWebViewController
    }
    
    func logError(text: String) {
        let preparedText = prepareLog(text: text, prefix: logErrorPrefix)
        logReadFromStandardInput(preparedText)
    }

    func logMessage(text: String) {
        let preparedText = prepareLog(text: text, prefix: logMessagePrefix)
        logReadFromStandardInput(preparedText)
    }
    
    func prepareLog(#text: String, prefix: String) -> String {
        var prependedText = prefix + text
        prependedText = prependedText.stringByReplacingOccurrencesOfString("\n", withString: "\n\(prefix)")
        prependedText += "\n"
        return prependedText
    }
    
    func logReadFromStandardInput(text: String) {
        var readReadFromStandardInputBlock = { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.logWebViewController.readFromStandardInput(text)
            }
        }
        
        if logWebViewController.plugin == nil {
            if let logPlugin = delegate?.logPluginForSplitWebViewController(self) {
                logWebViewController.runPlugin(logPlugin, withArguments: nil, inDirectoryPath: nil, completionHandler: { (success) -> Void in
                    readReadFromStandardInputBlock()
                })
            }
        } else {
            readReadFromStandardInputBlock()
        }
    }
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        splitController = SplitController(splitViewController: self, splitViewItem: logSplitViewItem)
        splitController.delegate = self
        
        for splitViewItem in splitViewItems {
            if let webViewController = splitViewItem.viewController as? WCLWebViewController {
                webViewController.delegate = self
            }
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        splitController.setCollapsed(true, animated: false)
    }

    // MARK: AppleScript
    
    func doJavaScript(javaScript: String) -> String? {
        return defaultWebViewController.doJavaScript(javaScript)
    }
    
    func loadHTML(HTML: String,
        baseURL: NSURL?,
        completionHandler:((Bool) -> Void)?)
    {
        defaultWebViewController.loadHTML(HTML,
            baseURL: baseURL,
            completionHandler: completionHandler)
    }
    
    func readFromStandardInput(text: String) {
        defaultWebViewController.readFromStandardInput(text)
    }
    
    func runPlugin(plugin: Plugin,
        withArguments arguments: [AnyObject]?,
        inDirectoryPath directoryPath: String?,
        completionHandler:((Bool) -> Void)?)
    {
        defaultWebViewController.runPlugin(plugin,
            withArguments: arguments,
            inDirectoryPath: directoryPath,
            completionHandler: completionHandler)
    }
    
    // MARK: Tasks
    
    func hasTasks() -> Bool {
        return tasks().count > 0
    }
    
    func tasks() -> [NSTask] {
        var tasks = [NSTask]()
        let splitViewItems = self.splitViewItems as! [NSSplitViewItem]
        
        for splitViewItem in splitViewItems {
            let webViewController = splitViewItem.viewController as! WCLWebViewController
            tasks += webViewController.tasks as! [NSTask]
        }
        return tasks
    }
    
    // MARK: Actions
    
    @IBAction func toggleLogShown(sender: AnyObject?) {
        toggleLog()
    }

    // MARK: Toggle Log

    func showLog() {
        splitController.setCollapsed(false, animated: true)
    }

    func hideLog() {
        splitController.setCollapsed(true, animated: true)
    }

    func toggleLog() {
        splitController.toggleCollapsed(true)
    }
    
    // MARK: Validation
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        switch menuItem.action {
        case Selector("toggleLogShown:"):
            if let collapsed = splitController.isCollapsed() {
                menuItem.title = collapsed ? "Show Log" : "Close Log"
                return true
            } else {
                return false
            }
        default:
            return super.validateMenuItem(menuItem)
        }
    }
    
    // MARK: NSSplitViewDelegate
    
    override func splitView(splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        if splitView != self.splitView {
            return false
        }
        
        return subview == splitController.splitViewsSubview
    }

    override func splitView(splitView: NSSplitView,
        shouldCollapseSubview subview: NSView,
        forDoubleClickOnDividerAtIndex dividerIndex: Int) -> Bool
    {
        if splitView != self.splitView {
            return false
        }
        
        return subview == splitController.splitViewsSubview
    }
    
    override func splitView(splitView: NSSplitView, shouldHideDividerAtIndex dividerIndex: Int) -> Bool {
        if dividerIndex == splitViewItemDividerIndex {
            if let collapsed = splitController.isCollapsed() {
                return collapsed
            }
        }
        return false
    }

    override func splitViewDidResizeSubviews(notification: NSNotification) {
        if let isVisible = delegate?.windowIsVisibleForSplitWebViewController(self) {
            if !isVisible {
                return
            }
        }
        
        if let collapsed = splitController.isCollapsed() {
            if !collapsed {
                splitController.saveFrame()
                splitController.configureHeight()
            }
        }
    }

    // MARK: SplitControllerDelegate
    
    func savedFrameNameForSplitController(splitController: SplitController) -> String? {
        if let pluginName = defaultWebViewController.plugin?.name {
            return self.dynamicType.savedFrameNameForPluginName(pluginName)
        }
        return nil
    }

    class func savedFrameNameForPluginName(pluginName: String) -> String {
        return "Log Frame " + pluginName
    }
    
    // MARK: WCLWebViewControllerDelegate
    
    func webViewControllerViewWillDisappear(webViewController: WCLWebViewController) {
        // No-op only tests use this now
    }
    
    func webViewControllerViewWillAppear(webViewController: WCLWebViewController) {
        if let superview = webViewController.view.superview {
            let view = webViewController.view
            
            let minimumHeightConstraint =  NSLayoutConstraint(item: view,
                attribute: .Height,
                relatedBy: .GreaterThanOrEqual,
                toItem: nil,
                attribute: .NotAnAttribute,
                multiplier: 1,
                constant: splitWebViewHeight)
            superview.addConstraint(minimumHeightConstraint)
            
            if view == splitController.splitsView {
                splitController.restoreFrame()
            }
        }
    }

    func windowForWebViewController(webViewController: WCLWebViewController) -> NSWindow {
        // TODO: Fortify this forced unwrap
        return delegate!.windowForSplitWebViewController(self)!
    }

    func webViewControllerWillLoadHTML(webViewController: WCLWebViewController) {
        delegate?.splitWebViewControllerWillLoadHTML(self)
    }

    func webViewController(webViewController: WCLWebViewController, didReceiveTitle title: String) {
        if webViewController == defaultWebViewController {
            // Don't set the title from the log
            delegate?.splitWebViewController(self, didReceiveTitle: title)
        }
    }
    
    func webViewController(webViewController: WCLWebViewController, taskWillStart task: NSTask) {
        delegate?.splitWebViewControllerWillStartTasks(self)
    }

    func webViewController(webViewController: WCLWebViewController, taskDidFinish task: NSTask) {
        if !hasTasks() {
            delegate?.splitWebViewControllerDidFinishTasks(self)
        }
    }

    func webViewController(webViewController: WCLWebViewController, didReceiveStandardOutput text: String) {
        if webViewController == logWebViewController {
            // Don't log messages from the log itself
            return
        }
        
        if shouldLog {
            logMessage(text)
        }
    }

    func webViewController(webViewController: WCLWebViewController, didReceiveStandardError text: String) {
        if webViewController == logWebViewController {
            // Don't log messages from the log itself
            return
        }
        
        if shouldLog {
            logError(text)
        }
    }
}
