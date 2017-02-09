//
//  PluginsDataControllerFileSystemTests.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/11/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
import XCTest

@testable import Web_Console

class PluginsDataControllerFileSystemTests: PluginsDataControllerEventTestCase {

    // MARK: File System Tests

    func testAddAndDeletePlugin() {
        let destinationPluginFilename = DuplicatePluginController.pluginFilename(fromName: plugin.identifier)
        let destinationPluginPath = pluginPath.deletingLastPathComponent.appendingPathComponent(destinationPluginFilename)

        var newPlugin: Plugin!
        copyPluginWithConfirmation(plugin, destinationPluginPath: destinationPluginPath, handler: { (copiedPlugin) -> Void in
            newPlugin = copiedPlugin
        })
        XCTAssertNotNil(newPlugin, "The plugin should not be nil")
        XCTAssertTrue(PluginsManager.sharedInstance.pluginsDataController.plugins().contains(newPlugin), "The plugins should contain the plugin")
        removePluginWithConfirmation(newPlugin)
        XCTAssertFalse(PluginsManager.sharedInstance.pluginsDataController.plugins().contains(newPlugin), "The plugins should not contain the plugin")
    }
    
    func testMovePlugin() {
        let destinationPluginFilename = DuplicatePluginController.pluginFilename(fromName: plugin.identifier)
        let destinationPluginPath = pluginPath.deletingLastPathComponent.appendingPathComponent(destinationPluginFilename)
        
        // Move the plugin
        var newPlugin: Plugin!
        movePluginWithConfirmation(plugin, destinationPluginPath: destinationPluginPath, handler: { (plugin) -> Void in
            newPlugin = plugin
        })
        XCTAssertNotNil(newPlugin, "The plugin should not be nil")
        XCTAssertFalse(PluginsManager.sharedInstance.pluginsDataController.plugins().contains(plugin), "The plugins should not contain the plugin")
        XCTAssertTrue(PluginsManager.sharedInstance.pluginsDataController.plugins().contains(newPlugin), "The plugins should contain the plugin")
        
        // Move the plugin back
        var newPluginTwo: Plugin!
        movePluginWithConfirmation(newPlugin, destinationPluginPath: pluginPath, handler: { (movedPlugin) -> Void in
            newPluginTwo = movedPlugin
        })
        XCTAssertNotNil(newPluginTwo, "The plugin should not be nil")
        XCTAssertFalse(PluginsManager.sharedInstance.pluginsDataController.plugins().contains(newPlugin), "The plugins should not contain the plugin")
        XCTAssertTrue(PluginsManager.sharedInstance.pluginsDataController.plugins().contains(newPluginTwo), "The plugins should contain the plugin")
    }
    
    func testEditPlugin() {        
        // Move the plugin
        var newPlugin: Plugin!
        modifyPluginWithConfirmation(plugin, handler: { (modifiedPlugin) -> Void in
            newPlugin = modifiedPlugin
        })
        XCTAssertNotNil(newPlugin, "The plugin should not be nil")
        XCTAssertFalse(PluginsManager.sharedInstance.pluginsDataController.plugins().contains(plugin), "The plugins should not contain the plugin")
        XCTAssertTrue(PluginsManager.sharedInstance.pluginsDataController.plugins().contains(newPlugin), "The plugins should contain the plugin")
    }

    // TODO: Test plugins made invalid are not loaded?
}
