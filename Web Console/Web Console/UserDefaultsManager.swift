//
//  UserDefaults.swift
//  Web Console
//
//  Created by Roben Kleene on 9/30/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation
import AppKit

@objc class UserDefaultsManager: NSObject {
    class func standardUserDefaults() -> NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }

    class func sharedUserDefaultsController() -> NSUserDefaultsController {
        return NSUserDefaultsController.sharedUserDefaultsController()
    }
}