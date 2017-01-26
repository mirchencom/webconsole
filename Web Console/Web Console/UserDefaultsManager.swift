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

    struct Singleton {
        static var overrideStandardUserDefaults: UserDefaults?
        static var overrideSharedUserDefaultsController: NSUserDefaultsController?
    }
    
    class func setOverrideStandardUserDefaults(userDefaults: UserDefaults?) {
        Singleton.overrideStandardUserDefaults = userDefaults
    }

    class func setOverrideSharedUserDefaultsController(userDefaultsController: NSUserDefaultsController?) {
        Singleton.overrideSharedUserDefaultsController = userDefaultsController
    }

    class func standardUserDefaults() -> UserDefaults {
        if let overrideStandardUserDefaults = Singleton.overrideStandardUserDefaults {
            return overrideStandardUserDefaults
        }

        return UserDefaults.standard
    }

    class func sharedUserDefaultsController() -> NSUserDefaultsController {
        if let overrideSharedUserDefaultsController = Singleton.overrideSharedUserDefaultsController {
            return overrideSharedUserDefaultsController
        }
        
        return NSUserDefaultsController.shared()
    }
}
