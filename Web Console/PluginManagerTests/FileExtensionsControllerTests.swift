//
//  WCLFileExtensionsControllerTests.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/23/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
import XCTest

@testable import Web_Console

class FileExtensionsControllerTests: FileExtensionsTestCase {

    func extensionsTest(_ extensions1: [String], matchExtensions extensions2: [String]) -> Bool {
        let sortedExtensions1: NSArray = extensions1.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        let sortedExtensions2: NSArray = extensions2.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        return sortedExtensions1 == sortedExtensions2
    }

    func testAddingPluginAndChangingFileExtensions() {
        let createdPlugin = newPluginWithConfirmation()
        XCTAssertFalse(FileExtensionsController.sharedInstance.suffixes().count > 0, "The file extensions count should be zero")
        
        createdPlugin.suffixes = testPluginSuffixesTwo
        let extensions: [String] = FileExtensionsController.sharedInstance.suffixes() as! [String]
        let extensionsMatch = extensionsTest(extensions, matchExtensions: testPluginSuffixesTwo)
        XCTAssertTrue(extensionsMatch, "The file extensions should match the test file extensions.")

        // Set file extensions to empty array
        createdPlugin.suffixes = testPluginSuffixesEmpty
 
        let extensionsTwo: [String] = FileExtensionsController.sharedInstance.suffixes() as! [String]
        let extensionsTwoMatch = extensionsTest(extensionsTwo, matchExtensions: testPluginSuffixesEmpty)
        XCTAssertTrue(extensionsTwoMatch, "The file extensions should match the empty test file extensions.")
    }

}

class FileExtensionsControllerBuiltInPluginsTests: XCTestCase {
    override func setUp() {
        super.setUp()
        let pluginsManager = PluginsManager([Directory.builtInPlugins.path()],
            duplicatePluginDestinationDirectoryURL: Directory.trash.URL())
        PluginsManager.setOverrideSharedInstance(pluginsManager)
        let fileExtensionsController = FileExtensionsController(pluginsManager: PluginsManager.sharedInstance)
        FileExtensionsController.setOverrideSharedInstance(fileExtensionsController)
    }
    
    override func tearDown() {
        FileExtensionsController.setOverrideSharedInstance(nil)
        PluginsManager.setOverrideSharedInstance(nil)
        super.tearDown()
    }

    func testStartingFileExtensions() {
        let controllerSet = NSSet(array: FileExtensionsController.sharedInstance.suffixes()) as Set
        
        // Get the plugins set
        let plugins = PluginsManager.sharedInstance.plugins()
        let pluginsSet = NSMutableSet()
        for plugin in plugins {
            pluginsSet.addObjects(from: plugin.suffixes)
        }

        XCTAssertTrue(pluginsSet.count > 0, "The cound should be greater than zero")
        XCTAssertTrue(pluginsSet.isEqual(to: controllerSet), "The sets should be equal")
    }

}


