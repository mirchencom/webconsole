//
//  WebViewControllerEventRouter.swift
//  Web Console
//
//  Created by Roben Kleene on 11/1/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

@testable import Web_Console

class WebViewControllerEventRouter: NSObject, WCLWebViewControllerDelegate {
    weak var delegate: WCLWebViewControllerDelegate!
    
    init(delegate: WCLWebViewControllerDelegate) {
        self.delegate = delegate
    }

    func windowForWebViewController(webViewController: WCLWebViewController) -> NSWindow {
        return self.delegate.windowForWebViewController(webViewController)
    }
//    - (nonnull NSWindow *)windowForWebViewController:(nonnull WCLWebViewController *)webViewController
    
    
    
    //    - (void)webViewControllerWillLoadHTML:(nonnull WCLWebViewController *)webViewController;
    //    - (void)webViewController:(nonnull WCLWebViewController *)webViewController
    //    didReceiveTitle:(nonnull NSString *)title;
    //    - (void)webViewController:(nonnull WCLWebViewController *)webViewController
    //    willStartTask:(nonnull NSTask *)task;
    //    - (void)webViewController:(nonnull WCLWebViewController *)webViewController
    //    didFinishTask:(nonnull NSTask *)task;
    //    - (void)webViewController:(nonnull WCLWebViewController *)webViewController
    //    didRunCommandPath:(nonnull NSString *)commandPath
    //    arguments:(nullable NSArray<NSString *> *)arguments
    //    directoryPath:(nullable NSString *)directoryPath;
    //    - (void)webViewController:(nonnull WCLWebViewController *)webViewController
    //    willDoJavaScript:(nonnull NSString *)text;
    //    - (void)webViewController:(nonnull WCLWebViewController *)webViewController
    //    didReadFromStandardInput:(nonnull NSString *)javaScript;
    //    - (void)webViewController:(nonnull WCLWebViewController *)webViewController
    //    didReceiveStandardOutput:(nonnull NSString *)text;
    //    - (void)webViewController:(nonnull WCLWebViewController *)webViewController
    //    didReceiveStandardError:(nonnull NSString *)text;
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