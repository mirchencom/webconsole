//
//  PluginsControllerTests.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/14/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
import XCTest

@testable import Web_Console

extension TemporaryPluginsTestCase {
    func fileURLOfDuplicatedItemAtURL(fileURL: URL, withFilename filename: String) -> URL {
        let destinationFileURL = fileURL.deletingLastPathComponent().appendingPathComponent(filename)
        do {
            try FileManager.default.copyItem(at: fileURL, to: destinationFileURL)
        } catch {
            XCTAssertTrue(false, "The copy should succeed")
        }
        return destinationFileURL
    }
}


class MultiCollectionControllerInitTests: PluginsManagerTestCase {

    func testInitPlugins() {
        let newPluginFilename = testDirectoryName
        let newPluginURL = fileURLOfDuplicatedItemAtURL(plugin.bundle.bundleURL, withFilename: newPluginFilename)
        let newPlugin = Plugin.makePlugin(url: newPluginURL)!
        
        let newPluginTwoFilename = testDirectoryNameTwo
        let newPluginTwoURL = fileURLOfDuplicatedItemAtURL(plugin.bundle.bundleURL, withFilename: newPluginTwoFilename)
        let newPluginTwo = Plugin.makePlugin(url: newPluginURL)!
        
        let newPluginChangedNameFilename = testDirectoryNameThree
        let newPluginChangedNameURL = fileURLOfDuplicatedItemAtURL(plugin.bundle.bundleURL, withFilename: newPluginChangedNameFilename)
        let newPluginChangedName = Plugin.makePlugin(url: newPluginURL)!
        let changedName = testDirectoryName
        newPluginChangedName.name = changedName
        
        let newPluginChangedNameTwoFilename = testDirectoryNameFour
        let newPluginChangedNameTwoURL = fileURLOfDuplicatedItemAtURL(plugin.bundle.bundleURL, withFilename: newPluginChangedNameTwoFilename)
        let newPluginChangedNameTwo = Plugin.makePlugin(url: newPluginURL)!
        newPluginChangedNameTwo.name = changedName
        
        let plugins = [plugin!, newPlugin, newPluginTwo, newPluginChangedName, newPluginChangedNameTwo]
        let newPluginURLs = [newPluginURL, newPluginTwoURL, newPluginChangedNameURL, newPluginChangedNameTwoURL]
        
        let pluginsController = MultiCollectionController(plugins, key: pluginNameKey)
        
        XCTAssertEqual(pluginsController.objects().count, 2, "The plugins count should be one")
        
        // Test New Plugins
        XCTAssertEqual(pluginsController.object(forKey: newPluginTwo.name)! as? Plugin, newPluginTwo, "The plugins should be equal")
        XCTAssertTrue(pluginsController.objects().contains(newPluginTwo), "The plugins should contain the second new plugin")
        XCTAssertFalse(pluginsController.objects().contains(newPlugin), "The plugins should not contain the new plugin")
        XCTAssertFalse(pluginsController.objects().contains(plugin), "The plugins should not contain the temporary plugin")
        
        // Test New Plugins Changed Name
        XCTAssertEqual(pluginsController.object(forKey: newPluginChangedNameTwo.name)! as? Plugin, newPluginChangedNameTwo, "The plugins should be equal")
        XCTAssertTrue(pluginsController.objects().contains(newPluginChangedNameTwo), "The plugins should contain the second new plugin changed name")
        XCTAssertFalse(pluginsController.objects().contains(newPluginChangedName), "The plugins should not contain the new plugin changed name")
        
        for pluginURL: URL in newPluginURLs {
            // Clean up
            do {
                try FileManager.default.removeItem(at: pluginURL)
            } catch {
                XCTAssertTrue(false, "The remove should succeed")
            }
        }
    }

}


class MultiCollectionControllerTests: PluginsManagerTestCase {
    var pluginsController: MultiCollectionController!
    
    override func setUp() {
        super.setUp()
        pluginsController = MultiCollectionController([plugin], key: pluginNameKey)
    }
    
    override func tearDown() {
        pluginsController = nil
        super.tearDown()
    }
    
    func testAddPlugin() {
        let destinationPluginURL = fileURLOfDuplicatedItemAtURL(plugin.bundle.bundleURL, withFilename: plugin.identifier)
        let newPlugin = Plugin.makePlugin(url: destinationPluginURL)!
        pluginsController.addObject(newPlugin)
        XCTAssertEqual(pluginsController.objects().count, 1, "The plugins count should be one")
        XCTAssertEqual(pluginsController.object(forKey: newPlugin.name)! as? Plugin, newPlugin, "The plugins should be equal")
        XCTAssertTrue(pluginsController.objects().contains(newPlugin), "The plugins should contain the new plugin")
        XCTAssertFalse(pluginsController.objects().contains(plugin), "The plugins should not contain the temporary plugin")
        
        // Clean up
        do {
            try FileManager.default.removeItem(at: destinationPluginURL)
        } catch {
            XCTAssertTrue(false, "The remove should succeed")
        }
    }

    func testAddPlugins() {

        let newPluginFilename = testDirectoryName
        let newPluginURL = fileURLOfDuplicatedItemAtURL(plugin.bundle.bundleURL, withFilename: newPluginFilename)
        let newPlugin = Plugin.makePlugin(url: newPluginURL)!

        let newPluginTwoFilename = testDirectoryNameTwo
        let newPluginTwoURL = fileURLOfDuplicatedItemAtURL(plugin.bundle.bundleURL, withFilename: newPluginTwoFilename)
        let newPluginTwo = Plugin.makePlugin(url: newPluginURL)!

        let newPluginChangedNameFilename = testDirectoryNameThree
        let newPluginChangedNameURL = fileURLOfDuplicatedItemAtURL(plugin.bundle.bundleURL, withFilename: newPluginChangedNameFilename)
        let newPluginChangedName = Plugin.makePlugin(url: newPluginURL)!
        let changedName = testDirectoryName
        newPluginChangedName.name = changedName

        let newPluginChangedNameTwoFilename = testDirectoryNameFour
        let newPluginChangedNameTwoURL = fileURLOfDuplicatedItemAtURL(plugin.bundle.bundleURL, withFilename: newPluginChangedNameTwoFilename)
        let newPluginChangedNameTwo = Plugin.makePlugin(url: newPluginURL)!
        newPluginChangedNameTwo.name = changedName
        
        let newPlugins = [newPlugin, newPluginTwo, newPluginChangedName, newPluginChangedNameTwo]
        let newPluginURLs = [newPluginURL, newPluginTwoURL, newPluginChangedNameURL, newPluginChangedNameTwoURL]
        
        pluginsController.addObjects(newPlugins)

        
        XCTAssertEqual(pluginsController.objects().count, 2, "The plugins count should be one")
        
        // Test New Plugins
        XCTAssertEqual(pluginsController.object(forKey: newPluginTwo.name)! as? Plugin, newPluginTwo, "The plugins should be equal")
        XCTAssertTrue(pluginsController.objects().contains(newPluginTwo), "The plugins should contain the second new plugin")
        XCTAssertFalse(pluginsController.objects().contains(newPlugin), "The plugins should not contain the new plugin")
        XCTAssertFalse(pluginsController.objects().contains(plugin), "The plugins should not contain the temporary plugin")
        
        // Test New Plugins Changed Name
        XCTAssertEqual(pluginsController.object(forKey: newPluginChangedNameTwo.name)! as? Plugin, newPluginChangedNameTwo, "The plugins should be equal")
        XCTAssertTrue(pluginsController.objects().contains(newPluginChangedNameTwo), "The plugins should contain the second new plugin changed name")
        XCTAssertFalse(pluginsController.objects().contains(newPluginChangedName), "The plugins should not contain the new plugin changed name")

        for pluginURL: URL in newPluginURLs {
            // Clean up
            do {
                try FileManager.default.removeItem(at: pluginURL)
            } catch {
                XCTAssertTrue(false, "The remove should succeed")
            }            
        }
    }
}
