//
//  Plugin+OrderedWindows.swift
//  Web Console
//
//  Created by Roben Kleene on 5/11/17.
//  Copyright © 2017 Roben Kleene. All rights reserved.
//

import Foundation

extension Plugin {

    // MARK: Windows

    func orderedWindows() -> [AnyObject]! {
        return WCLSplitWebWindowsController.shared().windows(for: self) as [AnyObject]!
    }

}

