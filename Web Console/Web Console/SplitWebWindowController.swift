//
//  PluginWindowController.swift
//  SplitViewPrototype
//
//  Created by Roben Kleene on 8/1/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Foundation
import AppKit

protocol SplitWebWindowControllerDelegate {
    func splitWebWindowControllerWindowDidClose(pluginWindowController: SplitWebWindowController)
}

class SplitWebWindowController: NSWindowController, NSWindowDelegate {
    var delegate: SplitWebWindowControllerDelegate?
    
    func windowWillClose(notification: NSNotification) {
        delegate?.splitWebWindowControllerWindowDidClose(self)
    }
}