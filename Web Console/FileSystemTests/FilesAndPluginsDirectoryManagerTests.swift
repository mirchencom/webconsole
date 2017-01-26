//
//  PluginsDirectoryManagerTests.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 11/8/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Foundation
import XCTest

@testable import Web_Console

protocol FilesAndPluginsDirectoryManagerFileDelegate {
    func testPluginsDirectoryManager(filesAndPluginsDirectoryManager: FilesAndPluginsDirectoryManager, fileWasCreatedOrModifiedAtPath path: String)
    func testPluginsDirectoryManager(filesAndPluginsDirectoryManager: FilesAndPluginsDirectoryManager, directoryWasCreatedOrModifiedAtPath path: String)
    func testPluginsDirectoryManager(filesAndPluginsDirectoryManager: FilesAndPluginsDirectoryManager, itemWasRemovedAtPath path: String)
}

class FilesAndPluginsDirectoryManager: PluginsDirectoryManager {
    var fileDelegate: FilesAndPluginsDirectoryManagerFileDelegate?
    
    override func directoryWatcher(directoryWatcher: WCLDirectoryWatcher!, directoryWasCreatedOrModifiedAtPath path: String!) {
        fileDelegate?.testPluginsDirectoryManager(self, directoryWasCreatedOrModifiedAtPath: path)
        super.directoryWatcher(directoryWatcher, directoryWasCreatedOrModifiedAtPath: path)
    }
    
    override func directoryWatcher(directoryWatcher: WCLDirectoryWatcher!, fileWasCreatedOrModifiedAtPath path: String!) {
        fileDelegate?.testPluginsDirectoryManager(self, fileWasCreatedOrModifiedAtPath: path)
        super.directoryWatcher(directoryWatcher, fileWasCreatedOrModifiedAtPath: path)
    }
    
    override func directoryWatcher(directoryWatcher: WCLDirectoryWatcher!, itemWasRemovedAtPath path: String!) {
        fileDelegate?.testPluginsDirectoryManager(self, itemWasRemovedAtPath: path)
        super.directoryWatcher(directoryWatcher, itemWasRemovedAtPath: path)
    }
}

class FilesAndPluginsDirectoryEventManager: PluginsDirectoryEventManager, FilesAndPluginsDirectoryManagerFileDelegate {
    var fileWasCreatedOrModifiedAtPathHandlers: Array<(path: String) -> Void>
    var directoryWasCreatedOrModifiedAtPathHandlers: Array<(path: String) -> Void>
    var itemWasRemovedAtPathHandlers: Array<(path: String) -> Void>

    override init() {
        self.fileWasCreatedOrModifiedAtPathHandlers = Array<(path: String) -> Void>()
        self.directoryWasCreatedOrModifiedAtPathHandlers = Array<(path: String) -> Void>()
        self.itemWasRemovedAtPathHandlers = Array<(path: String) -> Void>()
        super.init()
    }

    func testPluginsDirectoryManager(filesAndPluginsDirectoryManager: FilesAndPluginsDirectoryManager, fileWasCreatedOrModifiedAtPath path: String) {
        assert(fileWasCreatedOrModifiedAtPathHandlers.count > 0, "There should be at least one handler")
        
        if (fileWasCreatedOrModifiedAtPathHandlers.count > 0) {
            let handler = fileWasCreatedOrModifiedAtPathHandlers.remove(at: 0)
            handler(path)
        }
    }
    
    func testPluginsDirectoryManager(filesAndPluginsDirectoryManager: FilesAndPluginsDirectoryManager, directoryWasCreatedOrModifiedAtPath path: String) {
        assert(directoryWasCreatedOrModifiedAtPathHandlers.count > 0, "There should be at least one handler")
        
        if (directoryWasCreatedOrModifiedAtPathHandlers.count > 0) {
            let handler = directoryWasCreatedOrModifiedAtPathHandlers.remove(at: 0)
            handler(path)
        }
    }
    
    func testPluginsDirectoryManager(filesAndPluginsDirectoryManager: FilesAndPluginsDirectoryManager, itemWasRemovedAtPath path: String) {
        assert(itemWasRemovedAtPathHandlers.count > 0, "There should be at least one handler")
        
        if (itemWasRemovedAtPathHandlers.count > 0) {
            let handler = itemWasRemovedAtPathHandlers.remove(at: 0)
            handler(path)
        }
    }


    func addFileWasCreatedOrModifiedAtPathHandler(handler: @escaping (path: String) -> Void) {
        fileWasCreatedOrModifiedAtPathHandlers.append(handler)
    }
    
    func addDirectoryWasCreatedOrModifiedAtPathHandler(handler: @escaping (path: String) -> Void) {
        directoryWasCreatedOrModifiedAtPathHandlers.append(handler)
    }
    
    func addItemWasRemovedAtPathHandler(handler: @escaping (path: String) -> Void) {
        itemWasRemovedAtPathHandlers.append(handler)
    }
}

extension FilesAndPluginsDirectoryManagerTests {

    // MARK: Expectation Helpers
    
    func createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(path: String) {
        let pluginInfoDictionaryWasRemovedExpectation = expectation(description: "Plugin info dictionary was removed")
        fileAndPluginsDirectoryEventManager.addPluginInfoDictionaryWasRemovedAtPluginPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                pluginInfoDictionaryWasRemovedExpectation.fulfill()
            }
        })
    }
    
    func createExpectationForPluginInfoDictionaryWasCreatedOrModifiedAtPluginPath(path: String) {
        let pluginInfoDictionaryWasCreatedOrModifiedExpectation = expectation(description: "Plugin info dictionary was created or modified")
        fileAndPluginsDirectoryEventManager.addPluginInfoDictionaryWasCreatedOrModifiedAtPluginPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                pluginInfoDictionaryWasCreatedOrModifiedExpectation.fulfill()
            }
        })
    }
    
    
    // MARK: Create With Confirmation Helpers
    
    func createFileAtPathWithConfirmation(path: String) {
        let fileWasCreatedOrModifiedExpectation = expectation(description: "File was created")
        fileAndPluginsDirectoryEventManager.addFileWasCreatedOrModifiedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                fileWasCreatedOrModifiedExpectation.fulfill()
            }
        })
        SubprocessFileSystemModifier.createFileAtPath(path)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    
    func createDirectoryAtPathWithConfirmation(path: String) {
        let directoryWasCreatedOrModifiedExpectation = expectation(description: "Directory was created")
        fileAndPluginsDirectoryEventManager.addDirectoryWasCreatedOrModifiedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                directoryWasCreatedOrModifiedExpectation.fulfill()
            }
        })
        SubprocessFileSystemModifier.createDirectoryAtPath(path)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    
    
    // MARK: Remove With Confirmation Helpers
    
    func removeFileAtPathWithConfirmation(path: String) {
        let fileWasRemovedExpectation = expectation(description: "File was removed")
        fileAndPluginsDirectoryEventManager.addItemWasRemovedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                fileWasRemovedExpectation.fulfill()
            }
        })
        SubprocessFileSystemModifier.removeFileAtPath(path)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    
    func removeDirectoryAtPathWithConfirmation(path: String) {
        let directoryWasRemovedExpectation = expectation(description: "Directory was removed")
        fileAndPluginsDirectoryEventManager.addItemWasRemovedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                directoryWasRemovedExpectation.fulfill()
            }
        })
        SubprocessFileSystemModifier.removeDirectoryAtPath(path)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    
    
    // MARK: Move With Confirmation Helpers
    
    func moveDirectoryAtPathWithConfirmation(path: String, destinationPath: String) {
        // Remove original
        let directoryWasRemovedExpectation = expectation(description: "Directory was removed with move")
        fileAndPluginsDirectoryEventManager.addItemWasRemovedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                directoryWasRemovedExpectation.fulfill()
            }
        })
        // Create new
        let directoryWasCreatedExpectation = expectation(description: "Directory was created with move")
        fileAndPluginsDirectoryEventManager.addDirectoryWasCreatedOrModifiedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == destinationPath) {
                directoryWasCreatedExpectation.fulfill()
            }
        })
        // Move
        SubprocessFileSystemModifier.moveItemAtPath(path, toPath: destinationPath)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }

    func moveDirectoryAtUnwatchedPathWithConfirmation(path: String, destinationPath: String) {
        // Create new
        let directoryWasCreatedExpectation = expectation(description: "Directory was created with move")
        fileAndPluginsDirectoryEventManager.addDirectoryWasCreatedOrModifiedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == destinationPath) {
                directoryWasCreatedExpectation.fulfill()
            }
        })
        // Move
        let moveExpectation = expectation(description: "Move finished")
        SubprocessFileSystemModifier.moveItemAtPath(path, toPath: destinationPath, handler: {
            moveExpectation.fulfill()
        })
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }

    func moveDirectoryAtPathWithConfirmation(path: String, toUnwatchedDestinationPath destinationPath: String) {
        // Remove original
        let directoryWasRemovedExpectation = expectation(description: "Directory was removed with move")
        fileAndPluginsDirectoryEventManager.addItemWasRemovedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                directoryWasRemovedExpectation.fulfill()
            }
        })
        // Move
        let moveExpectation = expectation(description: "Move finished")
        SubprocessFileSystemModifier.moveItemAtPath(path, toPath: destinationPath, handler: {
            moveExpectation.fulfill()
        })
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }


    // MARK: Plugin File Hierarchy Helpers

    func createDirectoryAtPath(path: String) {
        do {
            try FileManager.default
                .createDirectory(atPath: path,
                    withIntermediateDirectories: false,
                    attributes: nil)
        } catch let error as NSError {
            XCTAssertTrue(false, "Creating the directory should succeed. \(error)")
        }
    }
    
    func createFileAtPath(path: String) {
        let success = FileManager.default.createFile(atPath: path,
            contents: nil,
            attributes: nil)
        XCTAssertTrue(success, "Creating the file should succeed.")
    }
    

    func createValidPluginHierarchyAtPath(path: String) {
        validPluginHierarchyOperation(path, isRemove: false, requireConfirmation: false)
    }

    func createValidPluginHierarchyAtPathWithConfirmation(path: String) {
        validPluginHierarchyOperation(path, isRemove: false, requireConfirmation: true)
    }
    
    func removeValidPluginHierarchyAtPath(path: String) {
        validPluginHierarchyOperation(path, isRemove: true, requireConfirmation: false)
    }

    func removeValidPluginHierarchyAtPathWithConfirmation(path: String) {
        validPluginHierarchyOperation(path, isRemove: true, requireConfirmation: true)
    }

    
    func validPluginHierarchyOperation(path: String, isRemove: Bool, requireConfirmation: Bool) {
        let testPluginDirectoryPath = path.stringByAppendingPathComponent(testPluginDirectoryName)
        let testPluginContentsDirectoryPath = testPluginDirectoryPath.stringByAppendingPathComponent(testPluginContentsDirectoryName)
        let testPluginResourcesDirectoryPath = testPluginContentsDirectoryPath.stringByAppendingPathComponent(testPluginResourcesDirectoryName)
        let testPluginResourcesFilePath = testPluginResourcesDirectoryPath.stringByAppendingPathComponent(testFilename)
        let testPluginContentsFilePath = testPluginContentsDirectoryPath.stringByAppendingPathComponent(testFilename)
        let testInfoDictionaryFilePath = testPluginContentsDirectoryPath.stringByAppendingPathComponent(testPluginInfoDictionaryFilename)

        
        if !isRemove {
            if !requireConfirmation {
                createDirectoryAtPath(testPluginDirectoryPath)
                createDirectoryAtPath(testPluginContentsDirectoryPath)
                createDirectoryAtPath(testPluginResourcesDirectoryPath)
                createFileAtPath(testPluginResourcesFilePath)
                createFileAtPath(testPluginContentsFilePath)
                createFileAtPath(testInfoDictionaryFilePath)
            } else {
                createDirectoryAtPathWithConfirmation(testPluginDirectoryPath)
                createDirectoryAtPathWithConfirmation(testPluginContentsDirectoryPath)
                createDirectoryAtPathWithConfirmation(testPluginResourcesDirectoryPath)
                createFileAtPathWithConfirmation(testPluginResourcesFilePath)
                createFileAtPathWithConfirmation(testPluginContentsFilePath)
                createExpectationForPluginInfoDictionaryWasCreatedOrModifiedAtPluginPath(testPluginDirectoryPath)
                createFileAtPathWithConfirmation(testInfoDictionaryFilePath)
            }
        } else {
            if !requireConfirmation {
                let testPluginDirectoryPath = path.stringByAppendingPathComponent(testPluginDirectoryName)
                do {
                    try removeTemporaryItemAtPath(testPluginDirectoryPath)
                } catch let error as NSError {
                    XCTAssertTrue(false, "Removing the directory should succeed. \(error)")
                }
            } else {
                createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
                removeFileAtPathWithConfirmation(testInfoDictionaryFilePath)

                removeFileAtPathWithConfirmation(testPluginResourcesFilePath)
                removeDirectoryAtPathWithConfirmation(testPluginResourcesDirectoryPath)
                removeFileAtPathWithConfirmation(testPluginContentsFilePath)

                createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
                removeDirectoryAtPathWithConfirmation(testPluginContentsDirectoryPath)
                
                createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
                removeDirectoryAtPathWithConfirmation(testPluginDirectoryPath)
            }
        }
    }
}


class FilesAndPluginsDirectoryManagerTests: TemporaryPluginsTestCase {
    var fileAndPluginsDirectoryManager: FilesAndPluginsDirectoryManager!
    var fileAndPluginsDirectoryEventManager: FilesAndPluginsDirectoryEventManager!

    // MARK: setUp & tearDown

    override func setUp() {
        super.setUp()
        fileAndPluginsDirectoryManager = FilesAndPluginsDirectoryManager(pluginsDirectoryURL: pluginsDirectoryURL)
        fileAndPluginsDirectoryEventManager = FilesAndPluginsDirectoryEventManager()
        fileAndPluginsDirectoryManager.delegate = fileAndPluginsDirectoryEventManager
        fileAndPluginsDirectoryManager.fileDelegate = fileAndPluginsDirectoryEventManager
    }
    
    override func tearDown() {
        fileAndPluginsDirectoryManager.fileDelegate = nil
        fileAndPluginsDirectoryManager.delegate = nil
        fileAndPluginsDirectoryEventManager = nil
        fileAndPluginsDirectoryManager = nil // Make sure this happens after setting its delegate to nil
        super.tearDown()
    }
    
    func testValidPluginFileHierarchy() {

        // Create a directory in the plugins directory, this should not cause a callback
        let testPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        createDirectoryAtPathWithConfirmation(testPluginDirectoryPath)
        
        // Create a file in the plugins directory, this should not cause a callback
        let testFilePath = pluginsDirectoryPath.stringByAppendingPathComponent(testFilename)
        createFileAtPathWithConfirmation(testFilePath)
        
        // Create the contents directory, this should not cause a callback
        let testPluginContentsDirectoryPath = testPluginDirectoryPath.stringByAppendingPathComponent(testPluginContentsDirectoryName)
        createDirectoryAtPathWithConfirmation(testPluginContentsDirectoryPath)
        
        // Create a file in the contents directory, this should not cause a callback
        let testPluginContentsFilePath = testPluginContentsDirectoryPath.stringByAppendingPathComponent(testFilename)
        createFileAtPathWithConfirmation(testPluginContentsFilePath)
        
        // Create the resource directory, this should not cause a callback
        let testPluginResourcesDirectoryPath = testPluginContentsDirectoryPath.stringByAppendingPathComponent(testPluginResourcesDirectoryName)
        createDirectoryAtPathWithConfirmation(testPluginResourcesDirectoryPath)
        
        // Create a file in the resource directory, this should not cause a callback
        let testPluginResourcesFilePath = testPluginResourcesDirectoryPath.stringByAppendingPathComponent(testFilename)
        createFileAtPathWithConfirmation(testPluginResourcesFilePath)

        // Create an info dictionary in the contents directory, this should cause a callback
        let testInfoDictionaryFilePath = testPluginContentsDirectoryPath.stringByAppendingPathComponent(testPluginInfoDictionaryFilename)
        createExpectationForPluginInfoDictionaryWasCreatedOrModifiedAtPluginPath(testPluginDirectoryPath)
        createFileAtPathWithConfirmation(testInfoDictionaryFilePath)
        
        // Clean up
        
        // Remove the info dictionary in the contents directory, this should cause a callback
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        removeFileAtPathWithConfirmation(testInfoDictionaryFilePath)

        // Remove the file in the resource directory, this should not cause a callback
        removeFileAtPathWithConfirmation(testPluginResourcesFilePath)

        // Remove the resource directory, this should not cause a callback
        removeDirectoryAtPathWithConfirmation(testPluginResourcesDirectoryPath)
        
        // Remove the file in the contents directory, this should not cause a callback
        removeFileAtPathWithConfirmation(testPluginContentsFilePath)

        // Remove the contents directory, this should cause a callback
        // because this could be the delete after move of a valid plugin's contents directory
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        removeDirectoryAtPathWithConfirmation(testPluginContentsDirectoryPath)
        
        // Remove the file in the plugins directory, this should not cause a callback
        // because the file doesn't have the plugin file extension
        removeFileAtPathWithConfirmation(testFilePath)
        
        // Remove the directory in the plugins directory, this should cause a callback
        // because this could be the delete after move of a valid plugin
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        removeDirectoryAtPathWithConfirmation(testPluginDirectoryPath)
    }

    func testInvalidPluginFileHierarchy() {
        // Create an invalid contents directory in the plugins path, this should not cause a callback
        let testInvalidPluginContentsDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        createDirectoryAtPathWithConfirmation(testInvalidPluginContentsDirectoryPath)

        // Create a info dictionary in the invalid contents directory, this should not cause a callback
        let testInvalidInfoDictionaryPath = testInvalidPluginContentsDirectoryPath.stringByAppendingPathComponent(testPluginInfoDictionaryFilename)
        createFileAtPathWithConfirmation(testInvalidInfoDictionaryPath)
        

        // Clean up
        
        // Remove the info dictionary in the invalid contents directory, this should not cause a callback
        removeFileAtPathWithConfirmation(testInvalidInfoDictionaryPath)
        
        // Remove the invalid contents directory in the plugins path, this should cause a callback
        // because this could be the delete after move of a valid plugin
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testInvalidPluginContentsDirectoryPath)
        removeDirectoryAtPathWithConfirmation(testInvalidPluginContentsDirectoryPath)
    }

    func testFileForContentsDirectory() {
        // Create a directory in the plugins directory, this should not cause a callback
        let testPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        createDirectoryAtPathWithConfirmation(testPluginDirectoryPath)

        // Create the contents directory, this should not cause a callback
        let testPluginContentsFilePath = testPluginDirectoryPath.stringByAppendingPathComponent(testPluginContentsDirectoryName)
        createFileAtPathWithConfirmation(testPluginContentsFilePath)


        // Clean up
        
        // Remove the contents directory, this should cause a callback
        // because this could be the delete after move of a valid plugin's contents directory
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        removeFileAtPathWithConfirmation(testPluginContentsFilePath)
    
        // Remove the directory in the plugins directory, this should cause a callback
        // because this could be the delete after move of a valid plugin
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        removeDirectoryAtPathWithConfirmation(testPluginDirectoryPath)
    }

    func testDirectoryForInfoDictionary() {
        // Create a directory in the plugins directory, this should not cause a callback
        let testPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        createDirectoryAtPathWithConfirmation(testPluginDirectoryPath)
        
        // Create the contents directory, this should not cause a callback
        let testPluginContentsDirectoryPath = testPluginDirectoryPath.stringByAppendingPathComponent(testPluginContentsDirectoryName)
        createDirectoryAtPathWithConfirmation(testPluginContentsDirectoryPath)
        
        // Create a directory for the info dictionary, this should not cause a callback
        let testPluginInfoDictionaryDirectoryPath = testPluginContentsDirectoryPath.stringByAppendingPathComponent(testPluginInfoDictionaryFilename)
        createDirectoryAtPathWithConfirmation(testPluginInfoDictionaryDirectoryPath)
        
        // Clean up

        // Create a directory for the info dictionary, this should cause a callback
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        removeDirectoryAtPathWithConfirmation(testPluginInfoDictionaryDirectoryPath)
        
        // Remove the contents directory, this should cause a callback
        // because this could be the delete after move of a valid plugin's contents directory
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        removeDirectoryAtPathWithConfirmation(testPluginContentsDirectoryPath)
        
        // Remove the directory in the plugins directory, this should cause a callback
        // because this could be the delete after move of a valid plugin
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        removeDirectoryAtPathWithConfirmation(testPluginDirectoryPath)
    }

    func testMoveResourcesDirectory() {
        createValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)

        let testPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        let testPluginContentsDirectoryPath = testPluginDirectoryPath.stringByAppendingPathComponent(testPluginContentsDirectoryName)
        let testPluginResourcesDirectoryPath = testPluginContentsDirectoryPath.stringByAppendingPathComponent(testPluginResourcesDirectoryName)
        let testRenamedPluginResourcesDirectoryPath = testPluginContentsDirectoryPath.stringByAppendingPathComponent(testDirectoryName)
        moveDirectoryAtPathWithConfirmation(testPluginResourcesDirectoryPath, destinationPath: testRenamedPluginResourcesDirectoryPath)

        // Clean up
        moveDirectoryAtPathWithConfirmation(testRenamedPluginResourcesDirectoryPath, destinationPath: testPluginResourcesDirectoryPath)

        removeValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
    }

    func testMoveContentsDirectory() {
        createValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)

        let testPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        let testPluginContentsDirectoryPath = testPluginDirectoryPath.stringByAppendingPathComponent(testPluginContentsDirectoryName)
        let testRenamedPluginContentsDirectoryPath = testPluginDirectoryPath.stringByAppendingPathComponent(testDirectoryName)
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        moveDirectoryAtPathWithConfirmation(testPluginContentsDirectoryPath, destinationPath: testRenamedPluginContentsDirectoryPath)
        
        // Clean up
        createExpectationForPluginInfoDictionaryWasCreatedOrModifiedAtPluginPath(testPluginDirectoryPath)
        moveDirectoryAtPathWithConfirmation(testRenamedPluginContentsDirectoryPath, destinationPath: testPluginContentsDirectoryPath)

        removeValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
    }

    func testMovePluginDirectory() {
        createValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)

        let testPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        let testRenamedPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryNameTwo)
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        createExpectationForPluginInfoDictionaryWasCreatedOrModifiedAtPluginPath(testRenamedPluginDirectoryPath)
        moveDirectoryAtPathWithConfirmation(testPluginDirectoryPath, destinationPath: testRenamedPluginDirectoryPath)
        
        // Clean up
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testRenamedPluginDirectoryPath)
        createExpectationForPluginInfoDictionaryWasCreatedOrModifiedAtPluginPath(testPluginDirectoryPath)
        moveDirectoryAtPathWithConfirmation(testRenamedPluginDirectoryPath, destinationPath: testPluginDirectoryPath)

        removeValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
    }

    func testMovePluginFromAndToUnwatchedDirectory() {
        createValidPluginHierarchyAtPath(temporaryDirectoryPath)
        
        // Move from unwatched directory
        let testPluginDirectoryPath = temporaryDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        let testMovedPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        createExpectationForPluginInfoDictionaryWasCreatedOrModifiedAtPluginPath(testMovedPluginDirectoryPath)
        moveDirectoryAtUnwatchedPathWithConfirmation(testPluginDirectoryPath, destinationPath: testMovedPluginDirectoryPath)

        // Move to unwatched directory
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testMovedPluginDirectoryPath)
        moveDirectoryAtPathWithConfirmation(testMovedPluginDirectoryPath, toUnwatchedDestinationPath: testPluginDirectoryPath)

        // Clean up
        removeValidPluginHierarchyAtPath(temporaryDirectoryPath)
    }

    func testFileExtensionAsName() {
        createValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
        
        // Create a file named with just the file extension
        let testFilePath = pluginsDirectoryPath.stringByAppendingPathComponent(pluginFileExtension)
        createFileAtPathWithConfirmation(testFilePath)
        removeFileAtPathWithConfirmation(testFilePath)

        // Clean up
        removeValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
    }

    func testOnlyFileExtension() {
        createValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
        
        // Create a file named with just the file extension
        let testFilePath = pluginsDirectoryPath.stringByAppendingPathComponent(".\(pluginFileExtension)")
        createFileAtPathWithConfirmation(testFilePath)
        removeFileAtPathWithConfirmation(testFilePath)
        
        // Clean up
        removeValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
    }

    
    func testHiddenFile() {
        createValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
        
        // Create a hidden file
        let testFilePath = pluginsDirectoryPath.stringByAppendingPathComponent(testHiddenDirectoryName)
        createFileAtPathWithConfirmation(testFilePath)
        removeFileAtPathWithConfirmation(testFilePath)

        // Clean up
        removeValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
    }

    func testHiddenFileInPluginDirectory() {
        createValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
        // Create a hidden file
        let testPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        let testFilePath = testPluginDirectoryPath.stringByAppendingPathComponent(testHiddenDirectoryName)
        createFileAtPathWithConfirmation(testFilePath)
        removeFileAtPathWithConfirmation(testFilePath)

        // Clean up
        removeValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
    }

    func testRemoveAndAddPluginFileExtension() {
        createValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)

        // Move the directory, removing the plugin extension, this should cause a callback
        let testPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(testPluginDirectoryName)
        let movedPluginDirectoryFilename = testPluginDirectoryName.stringByDeletingPathExtension
        let movedPluginDirectoryPath = pluginsDirectoryPath.stringByAppendingPathComponent(movedPluginDirectoryFilename)
        createExpectationForPluginInfoDictionaryWasRemovedAtPluginPath(testPluginDirectoryPath)
        moveDirectoryAtPathWithConfirmation(testPluginDirectoryPath, destinationPath: movedPluginDirectoryPath)

        // Move the directory back, re-adding the file extension, this should cause a callback
        createExpectationForPluginInfoDictionaryWasCreatedOrModifiedAtPluginPath(testPluginDirectoryPath)
        moveDirectoryAtPathWithConfirmation(movedPluginDirectoryPath, destinationPath: testPluginDirectoryPath)

        // Clean up
        removeValidPluginHierarchyAtPathWithConfirmation(pluginsDirectoryPath)
    }
}
