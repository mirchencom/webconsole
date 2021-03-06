//
//  DirectoryTests.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 9/27/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Cocoa
import XCTest

@testable import Web_Console

class DirectoryTests: XCTestCase {

    func testBuiltInPluginsPath() {
        XCTAssert(Directory.builtInPlugins.path() == Bundle.main.builtInPlugInsPath!, "The paths should match")
    }
    
    func testApplicationSupport() {
        let applicationSupportDirectoryPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        let nameKey = kCFBundleNameKey! as String
        let applicationName = Bundle.main.infoDictionary![nameKey] as! String
        let applicationSupportPath = applicationSupportDirectoryPath
            .appendingPathComponent(applicationName)
        XCTAssert(applicationSupportPath == Directory.applicationSupport.path(), "The paths should match")
    }
    
    func testApplicationSupportPluginsPath() {
        let applicationSupportPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
        let nameKey = kCFBundleNameKey! as String
        let applicationName = Bundle.main.infoDictionary![nameKey] as! String
        let applicationSupportPluginsPath = applicationSupportPath
            .appendingPathComponent(applicationName)
            .appendingPathComponent(pluginsDirectoryPathComponent)
        XCTAssert(applicationSupportPluginsPath == Directory.applicationSupportPlugins.path(), "The paths should match")
    }

    func testCachesPath() {
        let cachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let nameKey = kCFBundleNameKey! as String
        let applicationName = Bundle.main.infoDictionary![nameKey] as! String
        let cachesPath = cachesDirectory
            .appendingPathComponent(applicationName)
        XCTAssert(cachesPath == Directory.caches.path(), "The paths should match")
    }
}
