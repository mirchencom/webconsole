//
//  PluginManagerTests.swift
//  PluginManagerTests
//
//  Created by Roben Kleene on 9/15/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Cocoa
import XCTest

class PluginsDataControllerClassTests: XCTestCase {
    
    func testPluginPaths() {
        let pluginsPath = NSBundle.mainBundle().builtInPlugInsPath!
        let pluginPaths = PluginsDataController.pathsForPluginsAtPath(pluginsPath)

        // Test plugin path counts
        do {
            let testPluginPaths = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(pluginsPath)
            XCTAssert(!testPluginPaths.isEmpty, "The test plugin paths count should be greater than zero")
            XCTAssert(testPluginPaths.count == pluginPaths.count, "The plugin paths count should equal the test plugin paths count")
        } catch {
            XCTAssertTrue(false, "Getting the contents should succeed")
        }
        
        // Test plugins can be created from all paths
        var plugins = [Plugin]()
        for pluginPath in pluginPaths {
            if let plugin = Plugin.pluginWithPath(pluginPath) {
                plugins.append(plugin)
            } else {
                XCTAssert(false, "The plugin should exist")
            }
        }

        let testPluginsCount = PluginsDataController.pluginsAtPluginPaths(pluginPaths).count
        XCTAssert(plugins.count == testPluginsCount, "The plugins count should equal the test plugins count")
    }

    func testExistingPlugins() {
        let pluginsDataController = PluginsDataController(testPluginsPaths, duplicatePluginDestinationDirectoryURL: Directory.Trash.URL())
        let plugins = pluginsDataController.plugins()
        
        var pluginPaths = [String]()
        for pluginsPath in testPluginsPaths {
            let paths = PluginsDataController.pathsForPluginsAtPath(pluginsPath)
            pluginPaths += paths
        }
        
        XCTAssert(!plugins.isEmpty, "The plugins should not be empty")
        XCTAssert(plugins.count == pluginPaths.count, "The plugins count should match the plugin paths count")
    }

}

extension TemporaryDirectoryTestCase {
    // MARK: Helpers
    
    func createFileWithConfirmationAtURL(URL: NSURL, contents: String) {
        let path = URL.path!
        let createSuccess = NSFileManager.defaultManager().createFileAtPath(path,
            contents: testFileContents.dataUsingEncoding(NSUTF8StringEncoding),
            attributes: nil)
        XCTAssertTrue(createSuccess, "Creating the file should succeed.")
    }
    
    func contentsOfFileAtURLWithConfirmation(URL: NSURL) throws -> String {
        do {
            let contents = try String(contentsOfURL: URL,
                encoding: NSUTF8StringEncoding)
            return contents
        } catch let error as NSError {
            throw error
        }
    }
    
    func confirmFileExistsAtURL(URL: NSURL) {
        var isDir: ObjCBool = false
        let exists = NSFileManager.defaultManager().fileExistsAtPath(URL.path!, isDirectory: &isDir)
        XCTAssertTrue(exists, "The file should exist")
        XCTAssertTrue(!isDir, "The file should not be a directory")
    }
}

class PluginsDataControllerTemporaryDirectoryTests: TemporaryDirectoryTestCase {
    
    func testCreateDirectoryIfMissing() {
        let directoryURL = temporaryDirectoryURL
            .URLByAppendingPathComponent(testDirectoryName)
            .URLByAppendingPathComponent(testDirectoryNameTwo)

        do {
            try PluginsDataController.createDirectoryIfMissing(directoryURL)
        } catch {
            XCTAssert(false, "Creating the directory should succeed")
        }
        
        var isDir: ObjCBool = false
        let exists = NSFileManager.defaultManager().fileExistsAtPath(directoryURL.path!, isDirectory: &isDir)
        XCTAssertTrue(exists, "The file should exist")
        XCTAssertTrue(isDir, "The file should be a directory")
        
        // Clean Up
        let rootDirectoryURL: NSURL! = directoryURL.URLByDeletingLastPathComponent
        do {
            try removeTemporaryItemAtURL(rootDirectoryURL)
        } catch {
            XCTAssertTrue(false, "The remove should succeed")
        }
    }
    
    func testCreateDirectoryWithPathBlocked() {
        let directoryURL = temporaryDirectoryURL
            .URLByAppendingPathComponent(testDirectoryName)

        // Create the blocking file
        createFileWithConfirmationAtURL(directoryURL, contents: testFileContents)
        
        // Attempt
        do {
            try PluginsDataController.createDirectoryIfMissing(directoryURL)
        } catch {
            XCTAssertTrue(false, "Creating the directory should succeed")
        }

        // Confirm the File Still Exists
        confirmFileExistsAtURL(directoryURL)
        
        // Confirm the Contents

        do {
            let contents = try contentsOfFileAtURLWithConfirmation(directoryURL)
            XCTAssertEqual(testFileContents, contents, "The contents should be equal")
        } catch {
            XCTAssertTrue(false, "Getting the contents should succeed")
        }
        
        // Clean Up
        do {
            try removeTemporaryItemAtURL(directoryURL)
        } catch {
            XCTAssertTrue(false, "The remove should succeed")
        }
    }

    func testCreateDirectoryWithFirstPathComponentBlocked() {
        let directoryURL = temporaryDirectoryURL
            .URLByAppendingPathComponent(testDirectoryName)
            .URLByAppendingPathComponent(testDirectoryNameTwo)
        let blockingFileURL = directoryURL.URLByDeletingLastPathComponent!
        
        // Create the blocking file
        createFileWithConfirmationAtURL(blockingFileURL, contents: testFileContents)
        
        // Attempt
        var didThrow = false
        do {
            try PluginsDataController.createDirectoryIfMissing(directoryURL)
        } catch {
            didThrow = true
        }
        XCTAssertTrue(didThrow, "The error should have been thrown")
        
        // Confirm the File Still Exists
        confirmFileExistsAtURL(blockingFileURL)
        
        // Confirm the Contents
        do {
            let contents = try contentsOfFileAtURLWithConfirmation(blockingFileURL)
            XCTAssertEqual(testFileContents, contents, "The contents should be equal")
        } catch {
            XCTAssertTrue(false, "Getting the contents should succeed")
        }

        // Clean Up
        do {
            try removeTemporaryItemAtURL(blockingFileURL)
        } catch {
            XCTAssertTrue(false, "The remove should succeed")
        }
    }

    func testCreateDirectoryWithSecondPathComponentBlocked() {
        let directoryURL = temporaryDirectoryURL
            .URLByAppendingPathComponent(testDirectoryName)
            .URLByAppendingPathComponent(testDirectoryNameTwo)
        
        // Create the first path so creating the blocking file doesn't fail
        let containerDirectoryURL = directoryURL.URLByDeletingLastPathComponent!
        do {
            try PluginsDataController.createDirectoryIfMissing(containerDirectoryURL)
        } catch {
            XCTAssertTrue(false, "Creating the directory should succeed")
        }
        
        // Create the blocking file
        createFileWithConfirmationAtURL(directoryURL, contents: testFileContents)
        
        // Attempt
        var didThrow = false
        do {
            try PluginsDataController.createDirectoryIfMissing(directoryURL)
        } catch {
            didThrow = true
        }
        XCTAssertTrue(didThrow, "The error should have been thrown")
        
        // Confirm the File Still Exists
        confirmFileExistsAtURL(directoryURL)
        
        // Confirm the Contents
        do {
            let contents = try contentsOfFileAtURLWithConfirmation(directoryURL)
            XCTAssertEqual(testFileContents, contents, "The contents should be equal")
        } catch {
            XCTAssertTrue(false, "Getting the contents should succeed")
        }
        
        // Clean Up
        do {
            try removeTemporaryItemAtURL(containerDirectoryURL)
        } catch {
            XCTAssertTrue(false, "The remove should succeed")
        }

    }

}

class PluginsDataControllerTests: PluginsDataControllerEventTestCase {

    var duplicatePluginRootDirectoryURL: NSURL {
        return temporaryDirectoryURL
                .URLByAppendingPathComponent(testApplicationSupportDirectoryName)
    }
    
    override var duplicatePluginDestinationDirectoryURL: NSURL {
        return duplicatePluginRootDirectoryURL
            .URLByAppendingPathComponent(applicationName)
            .URLByAppendingPathComponent(pluginsDirectoryPathComponent)
    }

    func cleanUpDuplicatedPlugins() {
        do {
            try removeTemporaryItemAtURL(duplicatePluginRootDirectoryURL)
        } catch {
            XCTAssertTrue(false, "The remove should succeed")
        }        
    }
    
    func testDuplicateAndTrashPlugin() {
        XCTAssertEqual(PluginsManager.sharedInstance.pluginsDataController.plugins().count, 1, "The plugins count should be one")
        
        var newPlugin: Plugin!
        
        let addedExpectation = expectationWithDescription("Plugin was added")
        pluginDataEventManager.addPluginWasAddedHandler({ (addedPlugin) -> Void in
            addedExpectation.fulfill()
        })

        let duplicateExpectation = expectationWithDescription("Plugin was duplicated")
        PluginsManager.sharedInstance.pluginsDataController.duplicatePlugin(plugin, handler: { (duplicatePlugin, error) -> Void in
            XCTAssertNil(error, "The error should be nil")
            newPlugin = duplicatePlugin
            duplicateExpectation.fulfill()
        })

        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)

        XCTAssertEqual(PluginsManager.sharedInstance.pluginsDataController.plugins().count, 2, "The plugins count should be two")
        XCTAssertTrue(PluginsManager.sharedInstance.pluginsDataController.plugins().contains(newPlugin!), "The plugins should contain the plugin")
        
        // Trash the duplicated plugin
        let removeExpectation = expectationWithDescription("Plugin was removed")
        pluginDataEventManager.addPluginWasRemovedHandler({ (removedPlugin) -> Void in
            XCTAssertEqual(newPlugin!, removedPlugin, "The plugins should be equal")
            removeExpectation.fulfill()
        })

        movePluginToTrashAndCleanUpWithConfirmation(newPlugin!)
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)
        cleanUpDuplicatedPlugins()
    }

    func testDuplicatePluginWithBlockingFile() {
        let createSuccess = NSFileManager.defaultManager().createFileAtPath(duplicatePluginRootDirectoryURL.path!,
            contents: nil,
            attributes: nil)
        XCTAssertTrue(createSuccess, "Creating the file should succeed.")
        
        let duplicateExpectation = expectationWithDescription("Plugin was duplicated")
        PluginsManager.sharedInstance.pluginsDataController.duplicatePlugin(plugin, handler: { (duplicatePlugin, error) -> Void in
            XCTAssertNil(duplicatePlugin, "The duplicate plugin should be nil")
            XCTAssertNotNil(error, "The error should not be nil")
            duplicateExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)
        cleanUpDuplicatedPlugins()
    }

    func testDuplicatePluginWithEarlyBlockingFile() {
        do {
            try PluginsDataController.createDirectoryIfMissing(duplicatePluginRootDirectoryURL.URLByDeletingLastPathComponent!)

        } catch {
            XCTAssertTrue(false, "Creating the directory should succeed")
        }

        // Block the destination directory with a file
        let createSuccess = NSFileManager.defaultManager().createFileAtPath(duplicatePluginRootDirectoryURL.path!,
            contents: nil,
            attributes: nil)
        XCTAssertTrue(createSuccess, "Creating the file should succeed.")
        
        let duplicateExpectation = expectationWithDescription("Plugin was duplicated")
        PluginsManager.sharedInstance.pluginsDataController.duplicatePlugin(plugin, handler: { (duplicatePlugin, error) -> Void in
            XCTAssertNil(duplicatePlugin, "The duplicate plugin should be nil")
            XCTAssertNotNil(error, "The error should not be nil")
            duplicateExpectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)
        cleanUpDuplicatedPlugins()
    }

}