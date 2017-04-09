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
    // MARK: Data Source
    func windowIsVisible(for splitWebViewController: SplitWebViewController) -> Bool
    func window(for splitWebViewController: SplitWebViewController) -> NSWindow
    func logPlugin(for splitWebViewController: SplitWebViewController) -> Plugin?
    // Mark: Events
    func splitWebViewController(_ splitWebViewController: SplitWebViewController, didReceiveTitle title: String)
    func splitWebViewControllerWillLoadHTML(_ splitWebViewController: SplitWebViewController)
    // MARK: Starting & Finishing Tasks
    func splitWebViewController(_ splitWebViewController: SplitWebViewController,
        willStartTask task: Process)
    func splitWebViewController(_ splitWebViewController: SplitWebViewController,
        didFinishTask task: Process)
    func splitWebViewController(_ splitWebViewController: SplitWebViewController,
        didFailToRunTask task: Process,
        error: NSError)
}

class SplitWebViewController: NSSplitViewController {

    // MARK: Properties
    
    weak var delegate: SplitWebViewControllerDelegate?
    lazy var splitController: SplitController = {
        let splitController = SplitController(splitViewController: self, splitViewItem: self.logSplitViewItem)
        splitController.delegate = self
        return splitController
    }()

    var splitViewItemDividerIndex: Int? {
        if let index = splitController.splitViewItemIndex {
            return index - 1
        }
        return nil
    }
    
    var defaultWebViewController: WCLWebViewController {
        let splitViewItem = splitViewItems.first!
        return splitViewItem.viewController as! WCLWebViewController
    }
    
    var plugin: Plugin? {
        return defaultWebViewController.plugin
    }
    
    var webViewControllers: [WCLWebViewController] {
        return splitViewItems.map { $0.viewController as! WCLWebViewController }
    }
    
    // MARK: Log
    
    var shouldDebugLog: Bool {
        if let debugModeEnabled = self.plugin?.debugModeEnabled {
            // The plugin's setting overrides the preference, so a plugin can
            // force debug mode on or off. The user preference is only used if
            // the key is missing.
            return debugModeEnabled
        }

        return UserDefaultsManager.standardUserDefaults().bool(forKey: debugModeEnabledKey)
    }
    
    var logSplitViewItem: NSSplitViewItem {
        return splitViewItems.last!
    }

    var logWebViewController: WCLWebViewController {
        let splitViewItem = splitViewItems.last!
        return splitViewItem.viewController as! WCLWebViewController
    }
    
    lazy var logReadFromStandardInputOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.isSuspended = true
        return queue
    }()
    
    func logDebugError(_ text: String) {
        if !shouldDebugLog {
            return
        }

        print("Debug Error: \(text)")

        let preparedText = prepareLog(text: text, prefix: logErrorPrefix)
        logReadFromStandardInput(text: preparedText)
    }

    func logDebugMessage(_ text: String) {
        if !shouldDebugLog {
            return
        }

        print("Debug Message: \(text)")

        let preparedText = prepareLog(text: text, prefix: logMessagePrefix)
        logReadFromStandardInput(text: preparedText)
    }
    
    func prepareLog(text: String, prefix: String) -> String {
        var prependedText = prefix + text
        prependedText = prependedText.replacingOccurrences(of: "\n", with: "\n\(prefix)")
        prependedText += "\n"
        return prependedText
    }
    
    func logReadFromStandardInput(text: String) {
        logReadFromStandardInputOperationQueue.addOperation { [weak self]() -> Void in
            if let strongSelf = self {
                strongSelf.logWebViewController.read(fromStandardInput: text)
            }
        }
        
        if logWebViewController.plugin == nil {
            if let logPlugin = delegate?.logPlugin(for: self) {
                logWebViewController.run(logPlugin,
                    withArguments: nil,
                    inDirectoryPath: nil,
                    completionHandler: { [weak self](success) -> Void in
                        if let strongSelf = self {
                            strongSelf.logReadFromStandardInputOperationQueue.isSuspended = false
                        }
                    })
            }
        }
    }
    
    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

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
    
    func doJavaScript(_ javaScript: String) -> String? {
        return defaultWebViewController.doJavaScript(javaScript)
    }
    
    func loadHTML(_ HTML: String,
        baseURL: URL?,
        completionHandler:((Bool) -> Void)?)
    {
        defaultWebViewController.loadHTML(HTML,
            baseURL: baseURL,
            completionHandler: completionHandler)
    }
    
    func readFromStandardInput(text: String) {
        defaultWebViewController.read(fromStandardInput: text)
    }
    
    func run(plugin: Plugin,
        withArguments arguments: [AnyObject]?,
        inDirectoryPath directoryPath: String?,
        completionHandler:((Bool) -> Void)?)
    {
        defaultWebViewController.run(plugin,
            withArguments: arguments,
            inDirectoryPath: directoryPath,
            completionHandler: completionHandler)
    }
    
    // MARK: Tasks
    
    func hasTasks() -> Bool {
        return tasks().count > 0
    }
    
    func tasks() -> [Process] {
        var tasks = [Process]()
        let splitViewItems = self.splitViewItems
        
        for splitViewItem in splitViewItems {
            let webViewController = splitViewItem.viewController as! WCLWebViewController
            tasks += webViewController.tasks
        }
        return tasks
    }
    
    // MARK: Actions
    
    @IBAction func toggleLogShown(_ sender: AnyObject?) {
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
        splitController.toggleCollapsed(animated: true)
    }
    
    // MARK: Validation
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        guard let action = menuItem.action else {
            return super.validateMenuItem(menuItem)
        }
        
        switch action {
        case #selector(SplitWebViewController.toggleLogShown(_:)):
            if let collapsed = splitController.isCollapsed() {
                menuItem.title = collapsed ? showLogMenuItemTitle : hideLogMenuItemTitle
                return true
            } else {
                return false
            }
        default:
            return super.validateMenuItem(menuItem)
        }
    }
    
    // MARK: NSSplitViewDelegate
    
    override func splitView(_ splitView: NSSplitView,
        shouldCollapseSubview subview: NSView,
        forDoubleClickOnDividerAt dividerIndex: Int) -> Bool
    {
        if splitView != self.splitView {
            return false
        }
        
        return subview == splitController.splitViewsSubview
    }

    // If `splitView(_:shouldHideDividerAt:)` and 
    // `splitView(_:canCollapseSubview:)` both return `true`, and the divider
    // is attempted to be hidden then the following warning fires in the 
    // console:
    // "[Layout] Detected missing constraints for <private>.  It cannot be placed
    // because there are not enough constraints to fully define the size and
    // origin. Add the missing constraints, or set 
    // `translatesAutoresizingMaskIntoConstraints=YES` and constraints will be 
    // generated for you. If this view is laid out manually on macOS 10.12 and 
    // later, you may choose to not call [super layout] from your override.
    // Set a breakpoint on DETECTED_MISSING_CONSTRAINTS to debug.
    // This error will only be logged once."
    override func splitView(_ splitView: NSSplitView, canCollapseSubview subview: NSView) -> Bool {
        if splitView != self.splitView {
            return false
        }
        
        return subview == splitController.splitViewsSubview
    }
    
    override func splitView(_ splitView: NSSplitView, shouldHideDividerAt dividerIndex: Int) -> Bool {
        if dividerIndex == splitViewItemDividerIndex {
            if let collapsed = splitController.isCollapsed() {
                return collapsed
            }
        }
        return false
    }

    override func splitViewDidResizeSubviews(_ notification: Notification) {
        guard let isVisible = delegate?.windowIsVisible(for: self), isVisible == true else {
            return
        }
        
        if let collapsed = splitController.isCollapsed() {
            if !collapsed {
                splitController.saveFrame()
                splitController.configureForFrameHeight()
            }
        }
    }
}

extension SplitWebViewController: SplitControllerDelegate {
    func savedFrameName(for splitController: SplitController) -> String? {
        if let pluginName = defaultWebViewController.plugin?.name {
            return type(of: self).savedFrameName(for: pluginName)
        }
        return nil
    }
    
    class func savedFrameName(for pluginName: String) -> String {
        return "Log Frame " + pluginName
    }
}

extension SplitWebViewController: WCLWebViewControllerDelegate {
    
    // MARK: Life Cycle
    
    func webViewControllerViewWillDisappear(_ webViewController: WCLWebViewController) {
        // No-op only tests use this now
    }
    
    func webViewControllerViewWillAppear(_ webViewController: WCLWebViewController) {
        if let superview = webViewController.view.superview {
            let view = webViewController.view
            
            let minimumHeightConstraint =  NSLayoutConstraint(item: view,
                attribute: .height,
                relatedBy: .greaterThanOrEqual,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: splitWebViewHeight)
            superview.addConstraint(minimumHeightConstraint)
            
            if view == splitController.splitsView {
                splitController.restoreFrame()
            }
        }
    }
    
    func window(for webViewController: WCLWebViewController) -> NSWindow {
        // TODO: Fortify this forced unwrap
        return delegate!.window(for: self)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, didReceiveTitle title: String) {
        if webViewController == defaultWebViewController {
            // Don't set the title from the log
            delegate?.splitWebViewController(self, didReceiveTitle: title)
        }
    }

    // MARK: Starting & Finishing Tasks
    
    func webViewController(_ webViewController: WCLWebViewController, willStart task: Process) {
        delegate?.splitWebViewController(self, willStartTask: task)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, didFinish task: Process) {
        delegate?.splitWebViewController(self, didFinishTask: task)
        
        if webViewController == logWebViewController {
            // Don't log messages from the log itself
            return
        }
        
        if let commandName = task.launchPath?.lastPathComponent {
            let text = "Finished running: \(commandName)"
            logDebugMessage(text)
        }
    }
    
    func webViewController(_ webViewController: WCLWebViewController,
                           didFailToRun task: Process,
                           commandPath: String,
                           error: Error)
    {
        delegate?.splitWebViewController(self, didFailToRunTask: task, error: error as NSError)
        
        if webViewController == logWebViewController {
            // Don't log messages from the log itself
            return
        }
        
        logDebugError("Failed to run: \(commandPath.lastPathComponent)\nError: \(error.localizedDescription)")
    }
    
    func webViewController(_ webViewController: WCLWebViewController,
        didFailToRun task: Process,
        commandPath: String, error: NSError)
    {
    }

    func webViewController(_ webViewController: WCLWebViewController,
        didRunCommandPath commandPath: String,
        arguments: [String]?,
        directoryPath: String?)
    {
        if webViewController == logWebViewController {
            // Don't log messages from the log itself
            return
        }
        
        var items = [String]()
        let commandName = commandPath.lastPathComponent
        items.append("Running: \(commandName)")
        if let arguments = arguments {
            let item = arguments.joined(separator: ", ")
            items.append("With arguments: \(item)")
        }
        
        if let directoryPath = directoryPath {
            items.append("In directory: \(directoryPath)")
        }
        
        let text = items.joined(separator: "\n")
        
        logDebugMessage(text)
    }
    
    // MARK: Events
    
    func webViewController(_ webViewController: WCLWebViewController, didReadFromStandardInput text: String) {
        if webViewController == logWebViewController {
            // Don't log messages from the log itself
            return
        }
        
        let text = "Read from standard input: \(text)"
        logDebugMessage(text)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, willDoJavaScript javaScript: String) {
        if webViewController == logWebViewController {
            // Don't log messages from the log itself
            return
        }
        
        let text = "Do JavaScript: \(javaScript)"
        logDebugMessage(text)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, willLoadHTML HTML: String) {
        delegate?.splitWebViewControllerWillLoadHTML(self)

        if webViewController == logWebViewController {
            // Don't log messages from the log itself
            return
        }

        let text = "Load HTML: \(HTML)"
        logDebugMessage(text)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, didReceiveStandardOutput text: String) {
        if webViewController == logWebViewController {
            // Don't log messages from the log itself
            return
        }
        
        logDebugMessage(text)
    }
    
    func webViewController(_ webViewController: WCLWebViewController, didReceiveStandardError text: String) {
        if webViewController == logWebViewController {
            // Don't log messages from the log itself
            return
        }
        
        logDebugError(text)
    }

}
