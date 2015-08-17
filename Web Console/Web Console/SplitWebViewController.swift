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
    func windowNumberForSplitWebViewController(splitWebViewController: SplitWebViewController) -> NSNumber!
    func splitWebViewController(splitWebViewController: SplitWebViewController, didReceiveTitle title: String)
    func splitWebViewControllerWillLoadHTML(splitWebViewController: SplitWebViewController)
    func splitWebViewControllerDidStartTasks(splitWebViewController: SplitWebViewController)
    func splitWebViewControllerDidFinishTasks(splitWebViewController: SplitWebViewController)
}

class SplitWebViewController: NSSplitViewController, WCLWebViewControllerDelegate, LogControllerDelegate {

    // MARK: Properties
    
    weak var delegate: SplitWebViewControllerDelegate?
    var logController: LogController!

    var logSplitViewItemDividerIndex: Int? {
        if let index = logController.logSplitViewItemIndex {
            return index - 1
        }
        return nil
    }
    
    var pluginWebViewController: WCLWebViewController {
        let splitViewItem = splitViewItems.first as! NSSplitViewItem
        return splitViewItem.viewController as! WCLWebViewController
    }
    
    var plugin: Plugin? {
        get {
            return pluginWebViewController.plugin
        }
        set {
            pluginWebViewController.plugin = newValue
        }
    }
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        logController = LogController(splitViewController: self, logSplitViewItem: splitViewItems.last as! NSSplitViewItem)
        logController.delegate = self
        
        for splitViewItem in splitViewItems {
            if let webViewController = splitViewItem.viewController as? WCLWebViewController {
                webViewController.delegate = self
            }
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        logController.setCollapsed(true, animated: false)
    }

    // MARK: AppleScript
    
    func doJavaScript(javaScript: String) -> String? {
        return pluginWebViewController.doJavaScript(javaScript)
    }
    
    func loadHTML(HTML: String, baseURL: NSURL?, completionHandler:((Bool) -> Void)?) {
        pluginWebViewController.loadHTML(HTML, baseURL: baseURL, completionHandler: completionHandler)
    }
    
    // MARK: Tasks
    
    func runTask(task: NSTask) {
        WCLPluginTask.runTask(task, delegate: pluginWebViewController)
    }
    
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
        logController.toggleCollapsed(true)
    }

    // MARK: Validation
    
    override func validateMenuItem(menuItem: NSMenuItem) -> Bool {
        switch menuItem.action {
        case Selector("toggleLogShown:"):
            if let collapsed = logController.isLogCollapsed() {
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
        
        return subview == logController.logSplitViewSubview
    }

    override func splitView(splitView: NSSplitView,
        shouldCollapseSubview subview: NSView,
        forDoubleClickOnDividerAtIndex dividerIndex: Int) -> Bool
    {
        if splitView != self.splitView {
            return false
        }
        
        return subview == logController.logSplitViewSubview
    }
    
    override func splitView(splitView: NSSplitView, shouldHideDividerAtIndex dividerIndex: Int) -> Bool {
        if dividerIndex == logSplitViewItemDividerIndex {
            if let collapsed = logController.isLogCollapsed() {
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
        
        if let collapsed = logController.isLogCollapsed() {
            if !collapsed {
                logController.saveFrame()
                logController.configureHeight()
            }
        }
    }

    // MARK: LogControllerDelegate
    
    func savedFrameNameForLogController(logController: LogController) -> String? {
        if let pluginName = pluginWebViewController.plugin?.name {
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
            
            if view == logController.logView {
                logController.restoreFrame()
            }
        }
    }

    func windowNumberForWebViewController(webViewController: WCLWebViewController) -> NSNumber {
        // TODO: Fortify this forced unwrap
        return delegate!.windowNumberForSplitWebViewController(self)!
    }

    func webViewControllerWillLoadHTML(webViewController: WCLWebViewController) {
        delegate?.splitWebViewControllerWillLoadHTML(self)
    }

    func webViewController(webViewController: WCLWebViewController, didReceiveTitle title: String) {
        delegate?.splitWebViewController(self, didReceiveTitle: title)
    }
    
    func webViewController(webViewController: WCLWebViewController, taskWillStart task: NSTask) {
        delegate?.splitWebViewControllerDidStartTasks(self)
    }

    func webViewController(webViewController: WCLWebViewController, taskDidFinish task: NSTask) {
        if !hasTasks() {
            delegate?.splitWebViewControllerDidFinishTasks(self)
        }
    }
    
}
