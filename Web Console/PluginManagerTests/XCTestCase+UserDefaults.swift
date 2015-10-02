//
//  XCTestCase+UserDefaults.swift
//  Web Console
//
//  Created by Roben Kleene on 10/1/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

@testable import Web_Console

let testMockUserDefaultsSuiteName = "WebConsoleTests"

extension XCTestCase {
    
    func mockUserDefaultsSetUp() {
        let userDefaultsURL = NSBundle.mainBundle().URLForResource(userDefaultsFilename, withExtension: userDefaultsFileExtension)!
        let userDefaultsDictionary = NSDictionary(contentsOfURL: userDefaultsURL) as! [String: AnyObject]
        let userDefaults = NSUserDefaults(suiteName: testMockUserDefaultsSuiteName)!
        userDefaults.registerDefaults(userDefaultsDictionary)
        let userDefaultsController = NSUserDefaultsController(defaults: userDefaults, initialValues: userDefaultsDictionary)
        UserDefaultsManager.setOverrideStandardUserDefaults(userDefaults)
        UserDefaultsManager.setOverrideSharedUserDefaultsController(userDefaultsController)
    }
    
    func mockUserDefaultsTearDown() {
        UserDefaultsManager.setOverrideStandardUserDefaults(nil)
        UserDefaultsManager.setOverrideSharedUserDefaultsController(nil)
    }

}