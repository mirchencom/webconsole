//
//  FileSystemTests.swift
//  FileSystemTests
//
//  Created by Roben Kleene on 9/29/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import XCTest

@testable import Web_Console

class PluginTests: PluginsManagerTestCase {

    func infoDictionaryContentsForPluginWithConfirmation(plugin: Plugin) -> String {
        let pluginInfoDictionaryPath = Plugin.infoDictionaryURLForPlugin(plugin).path!
        var infoDictionaryContents: String!
        do {
            infoDictionaryContents = try String(contentsOfFile: pluginInfoDictionaryPath, encoding: NSUTF8StringEncoding)
        } catch {
            XCTAssertTrue(false, "Getting the info dictionary contents should succeed")
        }
        
        return infoDictionaryContents
    }
    
    func testEditPluginProperties() {
        let contents = infoDictionaryContentsForPluginWithConfirmation(plugin)

        plugin.name = testPluginNameTwo
        let contentsTwo = infoDictionaryContentsForPluginWithConfirmation(plugin)
        XCTAssertNotEqual(contents, contentsTwo, "The contents should not be equal")

        plugin.command = testPluginCommandTwo
        let contentsThree = infoDictionaryContentsForPluginWithConfirmation(plugin)
        XCTAssertNotEqual(contentsTwo, contentsThree, "The contents should not be equal")

        let uuid = NSUUID()
        let uuidString = uuid.UUIDString
        plugin.identifier = uuidString
        let contentsFour = infoDictionaryContentsForPluginWithConfirmation(plugin)
        XCTAssertNotEqual(contentsThree, contentsFour, "The contents should not be equal")

        plugin.suffixes = testPluginSuffixesTwo
        let contentsFive = infoDictionaryContentsForPluginWithConfirmation(plugin)
        XCTAssertNotEqual(contentsFour, contentsFive, "The contents should not be equal")
        let newPlugin: Plugin! = Plugin.pluginWithURL(pluginURL)

        XCTAssertEqual(plugin.name, newPlugin.name, "The names should be equal")
        XCTAssertEqual(plugin.command!, newPlugin.command!, "The commands should be equal")
        XCTAssertEqual(plugin.identifier, newPlugin.identifier, "The identifiers should be equal")
        XCTAssertEqual(plugin.suffixes, newPlugin.suffixes, "The file extensions should be equal")
    }

    func testNameValidation() {
        plugin.name = testPluginName
        
        // Test that the name is valid for this plugin
        var name: AnyObject? = testPluginName
        do {
            try plugin.validateName(&name)
        } catch {
            XCTAssertTrue(false, "Validation should succeed")
        }

        // Test an invalid object
        name = []
        var error: NSError?
        do {
            try plugin.validateName(&name)
        } catch let nameError as NSError {
            error = nameError
        }
        XCTAssertNotNil(error, "The error should not be nil.")

        // Create a new plugin
        let createdPlugin = newPluginWithConfirmation()

        // Test that the name is not valid for another plugin
        error = nil
        name = testPluginName
        do {
            try createdPlugin.validateName(&name)
        } catch let nameError as NSError {
            error = nameError
        }
        XCTAssertNotNil(error, "The error should not be nil.")

        // Test that the new plugins name is invalid
        error = nil
        name = createdPlugin.name
        do {
            try plugin.validateName(&name)
        } catch let nameError as NSError {
            error = nameError
        }
        XCTAssertNotNil(error, "The error should not be nil.")
        // Inverse
        error = nil
        name = plugin.name
        do {
            try createdPlugin.validateName(&name)
        } catch let nameError as NSError {
            error = nameError
        }
        XCTAssertNotNil(error, "The error should not be nil.")
        
        // Test that the name is now valid for the second plugin
        name = plugin.name
        plugin.name = testPluginNameNoPlugin
        error = nil
        do {
            try createdPlugin.validateName(&name)
        } catch {
            XCTAssertTrue(false, "Validation should succeed")
        }

        // Test that the new name is now invalid
        error = nil
        name = plugin.name
        do {
            try createdPlugin.validateName(&name)
        } catch let nameError as NSError {
            error = nameError
        }
        XCTAssertNotNil(error, "The error should not be nil.")

        // Test that the created plugins name is valid after deleting
        error = nil
        name = createdPlugin.name
        do {
            try plugin.validateName(&name)
        } catch let nameError as NSError {
            error = nameError
        }
        XCTAssertNotNil(error, "The error should not be nil.")
        // Delete
        movePluginToTrashAndCleanUpWithConfirmation(createdPlugin)
        // Test that the new name is now valid
        error = nil;
        do {
            try plugin.validateName(&name)
        } catch {
            XCTAssertTrue(false, "Validation should succeed")
        }
    }

    func testSuffixValidation() {
        // Test Valid Extensions
        var suffixes: AnyObject? = testPluginSuffixesTwo
        do {
            try plugin.validateExtensions(&suffixes)
        } catch {
            XCTAssertFalse(true, "Validation should succeed.")
        }

        // Test Invalid Duplicate Extensions
        var error: NSError?
        suffixes = [testPluginSuffix, testPluginSuffix]
        do {
            try plugin.validateExtensions(&suffixes)
        } catch let nameError as NSError {
            error = nameError
        }
        XCTAssertNotNil(error, "The error should not be nil.")

        // Test Invalid Length Extensions
        error = nil
        suffixes = [testPluginSuffix, ""]
        do {
            try plugin.validateExtensions(&suffixes)
        } catch let validationError as NSError {
            error = validationError
        }
        XCTAssertNotNil(error, "The error should not be nil.")

        // Test Invalid Object Extensions
        error = nil
        suffixes = [testPluginSuffix, []]
        do {
            try plugin.validateExtensions(&suffixes)
        } catch let validationError as NSError {
            error = validationError
        }
        XCTAssertNotNil(error, "The error should not be nil.")

        // Test Invalid Character Extensions
        error = nil
        suffixes = [testPluginSuffix, "jkl;"]
        do {
            try plugin.validateExtensions(&suffixes)
        } catch let validationError as NSError {
            error = validationError
        }
        XCTAssertNotNil(error, "The error should not be nil.")
    }

    func testEquality() {
        let samePlugin: Plugin! = Plugin.pluginWithURL(pluginURL)
        XCTAssertNotEqual(plugin, samePlugin, "The plugins should not be equal")
        XCTAssertTrue(plugin.isEqualToPlugin(samePlugin), "The plugins should be equal")
        
        // Duplicate the plugins folder, this should not cause a second plugin to be added to the plugin manager since the copy originated from the same process
        let destinationPluginFilename = DuplicatePluginController.pluginFilenameFromName(plugin.identifier)
        let destinationPluginURL: NSURL! = pluginURL.URLByDeletingLastPathComponent?.URLByAppendingPathComponent(destinationPluginFilename)
        do {
            try NSFileManager.defaultManager().copyItemAtURL(pluginURL, toURL: destinationPluginURL)
        } catch {
            XCTAssertTrue(false, "The copy should succeed")
        }

        let newPlugin: Plugin! = Plugin.pluginWithURL(destinationPluginURL)
        XCTAssertNotEqual(plugin, newPlugin, "The plugins should not be equal")
        // This fails because the bundle URL and commandPath are different
        XCTAssertFalse(plugin.isEqualToPlugin(newPlugin), "The plugins should be equal")

        // TODO: It would be nice to test modifying properties, but there isn't a way to do that because with two separate plugin directories the command paths and info dictionary URLs will be different
    }
}

class DuplicatePluginNameValidationTests: XCTestCase {
    var mockPluginsManager: PluginNameMockPluginsManager!
    var plugin: Plugin!
    
    class PluginNameMockPluginsManager: PluginsManager {
        var pluginNames = [testPluginName]
        
        override func pluginWithName(name: String) -> Plugin? {
            if pluginNames.contains(name) {
                let plugin = super.pluginWithName(testPluginName)
                assert(plugin != nil, "The plugin should not be nil")
                return plugin
            }
            return nil
        }

        func pluginWithTestPluginNameTwo() -> Plugin {
            return super.pluginWithName(testPluginNameTwo)!
        }
    }
    
    override func setUp() {
        super.setUp()
        mockPluginsManager = PluginNameMockPluginsManager()
        plugin = mockPluginsManager.pluginWithTestPluginNameTwo()
        PluginsManager.setOverrideSharedInstance(mockPluginsManager)
    }

    override func tearDown() {
        mockPluginsManager = nil
        plugin = nil
        PluginsManager.setOverrideSharedInstance(nil)
        super.tearDown()
    }

    func testPluginNames() {
        let fromName = testPluginNameTwo
        
        for pluginNamesCount in 0...105 {
            let name = WCLPlugin.uniquePluginNameFromName(fromName, forPlugin: plugin)
            let suffix = pluginNamesCount + 1
            
            var testName: String!
            switch pluginNamesCount {
            case 0:
                testName = name
            case let x where x > 98:
                testName = plugin.identifier
            default:
                testName = "\(fromName) \(suffix)"
            }
            XCTAssertEqual(name, testName, "The name should equal the identifier")
            
            var nameToAdd = "\(fromName) \(suffix)"
            if pluginNamesCount == 0 {
                nameToAdd = fromName
            }
            mockPluginsManager.pluginNames.append(nameToAdd)
        }

    }
}

// TODO: Test trying to run a plugin that has been unloaded? After deleting it's resources
// TODO: Add tests for invalid plugin info dictionaries, e.g., file extensions and commands can be nil

