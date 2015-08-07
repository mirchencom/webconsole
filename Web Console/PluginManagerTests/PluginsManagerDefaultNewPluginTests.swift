//
//  PluginManagerDefaultNewPluginTests.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/17/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
import XCTest

class PluginsManagerDefaultNewPluginTests: PluginsManagerTestCase {

    func testInvalidDefaultNewPluginIdentifier() {
        PluginsManager.sharedInstance.defaultNewPlugin = nil
        let UUID = NSUUID()
        let UUIDString = UUID.UUIDString
        NSUserDefaults.standardUserDefaults().setObject(UUIDString, forKey: defaultNewPluginIdentifierKey)

        let defaultNewPlugin = PluginsManager.sharedInstance.defaultNewPlugin
        let initialDefaultNewPlugin: Plugin! = PluginsManager.sharedInstance.pluginWithName(initialDefaultNewPluginName)
        XCTAssertEqual(defaultNewPlugin, initialDefaultNewPlugin, "The plugins should be equal")
        
        let identifier = NSUserDefaults.standardUserDefaults().stringForKey(defaultNewPluginIdentifierKey)
        XCTAssertNil(identifier, "The default new WCLPlugin identifier should be nil.")
    }
    
    func testSettingAndDeletingDefaultNewPlugin() {
        var createdPlugin = newPluginWithConfirmation()
        PluginsManager.sharedInstance.defaultNewPlugin = createdPlugin
        
        // Assert the WCLPlugin's isDefaultNewPlugin property
        XCTAssertTrue(createdPlugin.defaultNewPlugin, "The WCLPlugin should be the default new WCLPlugin.")
        
        // Assert the default new plugin identifier in NSUserDefaults
        let defaultNewPluginIdentifier: String! = NSUserDefaults.standardUserDefaults().stringForKey(defaultNewPluginIdentifierKey)
        XCTAssertEqual(createdPlugin.identifier, defaultNewPluginIdentifier, "The default WCLPlugin's identifier should equal the WCLPlugin's identifier.")
        
        // Assert the default new plugin is returned from the WCLPluginManager
        let defaultNewPlugin = PluginsManager.sharedInstance.defaultNewPlugin
        XCTAssertEqual(defaultNewPlugin, createdPlugin, "The default new WCLPlugin should be the WCLPlugin.")
        
        movePluginToTrashAndCleanUpWithConfirmation(createdPlugin)
        
        let defaultNewPluginTwo = PluginsManager.sharedInstance.defaultNewPlugin
        let initialDefaultNewPlugin: Plugin! = PluginsManager.sharedInstance.pluginWithName(initialDefaultNewPluginName)
        XCTAssertEqual(defaultNewPluginTwo, initialDefaultNewPlugin, "The plugins should be equal")

        let defaultNewPluginIdentifierTwo = NSUserDefaults.standardUserDefaults().stringForKey(defaultNewPluginIdentifierKey)
        XCTAssertNil(defaultNewPluginIdentifierTwo, "The default new WCLPlugin identifier should be nil.")
    }
    

    func testDefaultNewPlugin() {
        var createdPlugin = newPluginWithConfirmation()

        PluginsManager.sharedInstance.defaultNewPlugin = createdPlugin
        
        createdPlugin.name = testPluginNameTwo
        createdPlugin.command = testPluginCommandTwo
        createdPlugin.suffixes = testPluginSuffixesTwo
        
        var createdPluginTwo = newPluginWithConfirmation()
        
        XCTAssertEqual(createdPlugin.suffixes, createdPluginTwo.suffixes, "The new WCLPlugin's file extensions should equal the WCLPlugin's file extensions.")

        let pluginFolderName = createdPluginTwo.bundle.bundlePath.lastPathComponent
        XCTAssertEqual(DuplicatePluginController.pluginFilenameFromName(createdPluginTwo.name), pluginFolderName, "The folder name should equal the plugin's name")
        
        let longName: String = createdPlugin.name
        XCTAssertTrue(longName.hasPrefix(createdPlugin.name), "The new WCLPlugin's name should start with the WCLPlugin's name.")
        XCTAssertNotEqual(createdPlugin.name, createdPluginTwo.name, "The new WCLPlugin's name should not equal the WCLPlugin's name.")

        XCTAssertEqual(createdPlugin.command!, createdPluginTwo.command!, "The new WCLPlugin's command should equal the WCLPlugin's command.")
        XCTAssertNotEqual(createdPlugin.identifier, createdPluginTwo.identifier, "The identifiers should not be equal")
    }
    
    func testSettingDefaultNewPluginToNil() {
        var createdPlugin = newPluginWithConfirmation()
        PluginsManager.sharedInstance.defaultNewPlugin = createdPlugin
        
        let defaultNewPluginIdentifier: String? = NSUserDefaults.standardUserDefaults().stringForKey(defaultNewPluginIdentifierKey)
        XCTAssertNotNil(defaultNewPluginIdentifier, "The identifier should not be nil")

        PluginsManager.sharedInstance.defaultNewPlugin = nil

        let defaultNewPluginIdentifierTwo: String? = NSUserDefaults.standardUserDefaults().stringForKey(defaultNewPluginIdentifierKey)
        XCTAssertNil(defaultNewPluginIdentifierTwo, "The identifier should be nil")
    }

    func testDefaultNewPluginKeyValueObserving() {
        var createdPlugin = newPluginWithConfirmation()
        XCTAssertFalse(createdPlugin.defaultNewPlugin, "The WCLPlugin should not be the default new WCLPlugin.")

        var isDefaultNewPlugin = createdPlugin.defaultNewPlugin
        WCLKeyValueObservingTestsHelper.observeObject(createdPlugin,
            forKeyPath: testPluginDefaultNewPluginKeyPath,
            options: NSKeyValueObservingOptions.New )
        {
            (change: [NSObject : AnyObject]!) -> Void in
            isDefaultNewPlugin = createdPlugin.defaultNewPlugin
        }
        PluginsManager.sharedInstance.defaultNewPlugin = createdPlugin
        XCTAssertTrue(isDefaultNewPlugin, "The key-value observing change notification for the WCLPlugin's default new WCLPlugin property should have occurred.")
        XCTAssertTrue(createdPlugin.defaultNewPlugin, "The WCLPlugin should be the default new WCLPlugin.")

        // Test that key-value observing notifications occur when second new plugin is set as the default new plugin
        var createdPluginTwo = newPluginWithConfirmation()
        
        XCTAssertFalse(createdPluginTwo.defaultNewPlugin, "The WCLPlugin should not be the default new WCLPlugin.")
        
        WCLKeyValueObservingTestsHelper.observeObject(createdPlugin,
            forKeyPath: testPluginDefaultNewPluginKeyPath,
            options: NSKeyValueObservingOptions.New )
            {
                (change: [NSObject : AnyObject]!) -> Void in
                isDefaultNewPlugin = createdPlugin.defaultNewPlugin
        }
        var isDefaultNewPluginTwo = createdPlugin.defaultNewPlugin
        WCLKeyValueObservingTestsHelper.observeObject(createdPluginTwo,
            forKeyPath: testPluginDefaultNewPluginKeyPath,
            options: NSKeyValueObservingOptions.New )
            {
                (change: [NSObject : AnyObject]!) -> Void in
                isDefaultNewPluginTwo = createdPluginTwo.defaultNewPlugin
        }
        PluginsManager.sharedInstance.defaultNewPlugin = createdPluginTwo
        XCTAssertTrue(isDefaultNewPluginTwo, "The key-value observing change notification for the WCLPlugin's default new WCLPlugin property should have occurred.")
        XCTAssertTrue(createdPluginTwo.defaultNewPlugin, "The WCLPlugin should be the default new WCLPlugin.")
        XCTAssertFalse(isDefaultNewPlugin, "The key-value observing change notification for the WCLPlugin's default new WCLPlugin property should have occurred.")
        XCTAssertFalse(createdPlugin.defaultNewPlugin, "The WCLPlugin should not be the default new WCLPlugin.")

        // Test that key-value observing notifications occur when the default new plugin is set to nil
        WCLKeyValueObservingTestsHelper.observeObject(createdPluginTwo,
            forKeyPath: testPluginDefaultNewPluginKeyPath,
            options: NSKeyValueObservingOptions.New )
            {
                (change: [NSObject : AnyObject]!) -> Void in
                isDefaultNewPluginTwo = createdPluginTwo.defaultNewPlugin
        }
        PluginsManager.sharedInstance.defaultNewPlugin = nil
        XCTAssertFalse(isDefaultNewPluginTwo, "The key-value observing change notification for the second WCLPlugin's default new WCLPlugin property should have occurred.")
        XCTAssertFalse(createdPluginTwo.defaultNewPlugin, "The second WCLPlugin should not be the default new WCLPlugin.")
    }
    
}