//
//  LogController.swift
//  Web Console
//
//  Created by Roben Kleene on 8/5/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Foundation
import AppKit

protocol SplitControllerDelegate: class {
    func savedFrameNameForSplitController(splitController: SplitController) -> String?
}

class SplitController {

    // MARK: Properties
    
    var splitViewItem: NSSplitViewItem
    private weak var splitViewController: NSSplitViewController?
    weak var delegate: SplitControllerDelegate?

    var splitsHeightConstraint: NSLayoutConstraint?
    
    func isCollapsed() -> Bool? {
        return splitViewItem.isCollapsed
    }

    private var savedFrameName: String? {
        return delegate?.savedFrameNameForSplitController(self)
    }
    
    private var splitsViewController: NSViewController? {
        return splitViewItem.viewController
    }
    
    var splitsView: NSView? {
        return splitsViewController?.view
    }
    
    var splitViewItemIndex: Int? {
        if let splitViewItems = splitViewController?.splitViewItems {
            return splitViewItems.index(of: splitViewItem)!
        }
        return nil
    }

    var splitViewsSubview: NSView? {
        if let index = splitViewItemIndex, let subview = splitViewController?.splitView.subviews[index] {
            return subview
        }
        return nil
    }
    
    
    // MARK: Life Cycle
    
    // TODO: Remove this after setup is done in interface builder
    init(splitViewController: NSSplitViewController, splitViewItem: NSSplitViewItem) {
        self.splitViewController = splitViewController
        self.splitViewItem = splitViewItem
    }
    
    // MARK: Toggle

    func toggleCollapsed(animated: Bool) {
        if let collapsed = isCollapsed() {
            setCollapsed(!collapsed, animated: animated)
        }
    }
    
    func setCollapsed(collapsed: Bool, animated: Bool) {
        if splitViewItem.isCollapsed != collapsed {
            if animated {
                splitViewItem.animator().isCollapsed = collapsed
            } else {
                splitViewItem.isCollapsed = collapsed
            }
        }
    }

    // MARK: Saving & Restoring Frame
    
    func restoreFrame() {
        if let frame = savedSplitsViewFrame() {
            configureHeight(frame.size.height)
        }
    }
    
    func saveFrame() {
        guard let splitsView = splitsView, let key = savedFrameName else {
            return
        }
        
        let frame = splitsView.frame
        let frameString = NSStringFromRect(frame)
        UserDefaultsManager.standardUserDefaults().set(frameString, forKey:key)
    }

    class func savedFrameForName(name: String) -> NSRect? {
        if let frameString = UserDefaultsManager.standardUserDefaults().string(forKey: name) {
            let frame = NSRectFromString(frameString)
            return frame
        }
        return nil
    }
    
    func savedSplitsViewFrame() -> NSRect? {
        if let savedFrameName = savedFrameName {
            return type(of: self).savedFrameForName(savedFrameName)
        }
        return nil
    }

    // MARK: Constraints
    
    func configureHeight() {
        if let frame = splitsView?.frame {
            configureHeight(frame.size.height)
        }
    }
    
    func configureHeight(height: CGFloat) {
        if let splitsView = splitsView, let superview = splitsView.superview {
            if let splitsHeightConstraint = splitsHeightConstraint {
                if splitsHeightConstraint.constant == height {
                    return
                }
                superview.removeConstraint(splitsHeightConstraint)
            }
            
            let heightConstraint =  NSLayoutConstraint(item: splitsView,
                attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1,
                constant: height)
            heightConstraint.priority = 300
            superview.addConstraint(heightConstraint)
            splitsHeightConstraint = heightConstraint
        }
    }

    
}
