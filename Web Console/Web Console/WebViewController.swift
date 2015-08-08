//
//  ViewController.swift
//  SplitViewPrototype
//
//  Created by Roben Kleene on 7/19/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
import WebKit

@objc protocol WebViewControllerDelegate: class {
    func webViewControllerViewWillAppear(webViewController: WebViewController)
    func webViewControllerViewWillDisappear(webViewController: WebViewController)
}

class WebViewController: NSViewController {

    @IBOutlet weak var delegate: WebViewControllerDelegate?
    
    // MARK: Life Cycle
    
    override func viewWillAppear() {
        super.viewWillAppear()
        delegate?.webViewControllerViewWillAppear(self)
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        delegate?.webViewControllerViewWillDisappear(self)
    }
}

