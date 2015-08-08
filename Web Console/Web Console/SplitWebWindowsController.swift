//
//  PluginWindowsController.swift
//  SplitViewPrototype
//
//  Created by Roben Kleene on 8/1/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Foundation
import AppKit

class SplitWebWindowsController: SplitWebWindowControllerDelegate {
    var splitWebWindowControllers: [SplitWebWindowController] = [SplitWebWindowController]()

    static let sharedInstance = SplitWebWindowsController()

    // `private` forces use of the singleton
    private init() {
        
    }
    
    func openNewSplitWebWindow() {
        let splitWebWindowController = addedSplitWebWindowController()
        splitWebWindowController.showWindow(nil)
        splitWebWindowController.window?.makeKeyAndOrderFront(nil)
    }
    
    private func addedSplitWebWindowController() -> SplitWebWindowController {
        let bundle = NSBundle(forClass: self.dynamicType)
        let storyboard = NSStoryboard(name: "Main", bundle: bundle)!
        let splitWebWindowController = storyboard.instantiateControllerWithIdentifier("PluginWindow") as! SplitWebWindowController
        splitWebWindowController.delegate = self
        addSplitWebWindowController(splitWebWindowController)
        return splitWebWindowController
    }
    
    private func addSplitWebWindowController(splitWebWindowController: SplitWebWindowController) {
        splitWebWindowControllers.append(splitWebWindowController)
    }

    private func removeSplitWebWindowController(splitWebWindowController: SplitWebWindowController) {
        var index = find(splitWebWindowControllers, splitWebWindowController)
        if let index = index {
            splitWebWindowControllers.removeAtIndex(index)
        }
    }

    // MARK: PluginWindowControllerDelegate
    
    func splitWebWindowControllerWindowDidClose(splitWebWindowController: SplitWebWindowController) {
        removeSplitWebWindowController(splitWebWindowController)
    }
}