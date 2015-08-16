//
//  ViewControllerEventManager.swift
//  SplitViewPrototype
//
//  Created by Roben Kleene on 8/3/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Foundation

class WCLWebViewControllerEventManager: NSObject, WCLWebViewControllerDelegate {
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
    
    func blockFired(webViewController: WCLWebViewController) {
        if viewWillAppearBlock == nil && viewWillDisappearBlock == nil {
            webViewController.delegate = self.storedDelegate
        }
    }
    
    // MARK: WCLWebViewControllerDelegate
    
    @objc func webViewControllerViewWillAppear(webViewController: WCLWebViewController) {
        if let viewWillAppearBlock = viewWillAppearBlock {
            viewWillAppearBlock(webViewController)
        } else {
            self.storedDelegate!.webViewControllerViewWillAppear!(webViewController)
        }
    }

    @objc func webViewControllerViewWillDisappear(webViewController: WCLWebViewController) {
        if let viewWillDisappearBlock = viewWillDisappearBlock {
            viewWillDisappearBlock(webViewController)
        } else {
            self.storedDelegate!.webViewControllerViewWillDisappear!(webViewController)
        }
    }
    
    func windowNumberForWebViewController(webViewController: WCLWebViewController) -> NSNumber {
        return self.storedDelegate!.windowNumberForWebViewController(webViewController)
    }
}
