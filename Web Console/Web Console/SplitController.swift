//
//  LogController.swift
//  Web Console
//
//  Created by Roben Kleene on 8/5/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Foundation
import AppKit

@objc protocol SplitControllerDelegate: class {
    func savedFrameNameForSplitController(splitController: SplitController) -> String?
}

@objc class SplitController {

    // MARK: Properties
    
    var splitViewItem: NSSplitViewItem
    private weak var splitViewController: NSSplitViewController?
    weak var delegate: SplitControllerDelegate?

    var splitsHeightConstraint: NSLayoutConstraint?
    
    func isCollapsed() -> Bool? {
        return splitViewItem.collapsed
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
        if let splitViewItems = splitViewController?.splitViewItems as? [NSSplitViewItem] {
            return find(splitViewItems, splitViewItem)!
        }
        return nil
    }

    var splitViewsSubview: NSView? {
        if let index = splitViewItemIndex, subview = splitViewController?.splitView.subviews[index] as? NSView {
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
        if splitViewItem.collapsed != collapsed {
            if animated {
                splitViewItem.animator().collapsed = collapsed
            } else {
                splitViewItem.collapsed = collapsed
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
        if let splitsView = splitsView, key = savedFrameName {
            let frame = splitsView.frame
            let frameString = NSStringFromRect(frame)
            NSUserDefaults.standardUserDefaults().setObject(frameString, forKey:key)
        }
    }

    class func savedFrameForName(name: String) -> NSRect? {
        if let frameString = NSUserDefaults.standardUserDefaults().stringForKey(name) {
            let frame = NSRectFromString(frameString)
            return frame
        }
        return nil
    }
    
    func savedSplitsViewFrame() -> NSRect? {
        if let savedFrameName = savedFrameName {
            return self.dynamicType.savedFrameForName(savedFrameName)
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
        if let splitsView = splitsView, superview = splitsView.superview {
            if let splitsHeightConstraint = splitsHeightConstraint {
                superview.removeConstraint(splitsHeightConstraint)
            }
            
            let heightConstraint =  NSLayoutConstraint(item: splitsView,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1,
                constant: height)
            // Getting closer, this works for subsequent displays but not the first
            heightConstraint.priority = 300
            superview.addConstraint(heightConstraint)
            splitsHeightConstraint = heightConstraint
        }
    }

    
}