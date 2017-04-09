//
//  WCLDirectoryWatcherTests.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 11/20/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Cocoa
import XCTest

@testable import Web_Console

class WCLDirectoryWatcherEventManager: NSObject, WCLDirectoryWatcherDelegate {
    var fileWasCreatedOrModifiedAtPathHandlers: Array<((_ path: String) -> Void)>
    var directoryWasCreatedOrModifiedAtPathHandlers: Array<((_ path: String) -> Void)>
    var itemWasRemovedAtPathHandlers: Array<((_ path: String) -> Void)>

    override init() {
        self.fileWasCreatedOrModifiedAtPathHandlers = Array<((_ path: String) -> Void)>()
        self.directoryWasCreatedOrModifiedAtPathHandlers = Array<((_ path: String) -> Void)>()
        self.itemWasRemovedAtPathHandlers = Array<((_ path: String) -> Void)>()
    }

    func directoryWatcher(directoryWatcher: WCLDirectoryWatcher!, fileWasCreatedOrModifiedAtPath path: String!) {
        assert(fileWasCreatedOrModifiedAtPathHandlers.count > 0, "There should be at least one handler")
        
        if (fileWasCreatedOrModifiedAtPathHandlers.count > 0) {
            let handler = fileWasCreatedOrModifiedAtPathHandlers.remove(at: 0)
            handler(path)
        }
    }
    
    func directoryWatcher(directoryWatcher: WCLDirectoryWatcher!, directoryWasCreatedOrModifiedAtPath path: String!) {
        assert(directoryWasCreatedOrModifiedAtPathHandlers.count > 0, "There should be at least one handler")
        
        if (directoryWasCreatedOrModifiedAtPathHandlers.count > 0) {
            let handler = directoryWasCreatedOrModifiedAtPathHandlers.remove(at: 0)
            handler(path)
        }
    }
    
    func directoryWatcher(directoryWatcher: WCLDirectoryWatcher!, itemWasRemovedAtPath path: String!) {
        assert(itemWasRemovedAtPathHandlers.count > 0, "There should be at least one handler")
        
        if (itemWasRemovedAtPathHandlers.count > 0) {
            let handler = itemWasRemovedAtPathHandlers.remove(at: 0)
            handler(path)
        }
    }

    func addFileWasCreatedOrModifiedAtPathHandler(handler: @escaping (_ path: String) -> Void) {
        fileWasCreatedOrModifiedAtPathHandlers.append(handler)
    }

    func addDirectoryWasCreatedOrModifiedAtPathHandler(handler: @escaping (_ path: String) -> Void) {
        directoryWasCreatedOrModifiedAtPathHandlers.append(handler)
    }

    func addItemWasRemovedAtPathHandler(handler: @escaping (_ path: String) -> Void) {
        itemWasRemovedAtPathHandlers.append(handler)
    }
}

class WCLDirectoryWatcherTestCase: TemporaryDirectoryTestCase {
    var directoryWatcher: WCLDirectoryWatcher!
    var directoryWatcherEventManager: WCLDirectoryWatcherEventManager!
    
    override func setUp() {
        super.setUp()
        directoryWatcher = WCLDirectoryWatcher(url: temporaryDirectoryURL as URL!)
        directoryWatcherEventManager = WCLDirectoryWatcherEventManager()
        directoryWatcher.delegate = directoryWatcherEventManager
    }
    
    override func tearDown() {
        directoryWatcherEventManager = nil
        directoryWatcher.delegate = nil
        directoryWatcher = nil
        super.tearDown()
    }

    // MARK: Create
    func createFileAtPathWithConfirmation(path: String) {
        let fileWasCreatedOrModifiedExpectation = expectation(description: "File was created")
        directoryWatcherEventManager?.addFileWasCreatedOrModifiedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                fileWasCreatedOrModifiedExpectation.fulfill()
            }
        })
        SubprocessFileSystemModifier.createFileAtPath(path)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    func createDirectoryAtPathWithConfirmation(path: String) {
        let directoryWasCreatedOrModifiedExpectation = expectation(description: "Directory was created")
        directoryWatcherEventManager?.addDirectoryWasCreatedOrModifiedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                directoryWasCreatedOrModifiedExpectation.fulfill()
            }
        })
        SubprocessFileSystemModifier.createDirectoryAtPath(path)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    
    // MARK: Modify
    func modifyFileAtPathWithConfirmation(path: String) {
        let fileWasModifiedExpectation = expectation(description: "File was modified")
        directoryWatcherEventManager?.addFileWasCreatedOrModifiedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                fileWasModifiedExpectation.fulfill()
            }
        })
        SubprocessFileSystemModifier.writeToFileAtPath(path, contents: testFileContents)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    
    // MARK: Remove
    func removeFileAtPathWithConfirmation(path: String) {
        let fileWasRemovedExpectation = expectation(description: "File was removed")
        directoryWatcherEventManager?.addItemWasRemovedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                fileWasRemovedExpectation.fulfill()
            }
        })
        SubprocessFileSystemModifier.removeFileAtPath(path)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    func removeDirectoryAtPathWithConfirmation(path: String) {
        let directoryWasRemovedExpectation = expectation(description: "Directory was removed")
        directoryWatcherEventManager?.addItemWasRemovedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                directoryWasRemovedExpectation.fulfill()
            }
        })
        SubprocessFileSystemModifier.removeDirectoryAtPath(path)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    
    // MARK: Move
    func moveFileAtPathWithConfirmation(path: String, destinationPath: String) {
        // Remove original
        let fileWasRemovedExpectation = expectation(description: "File was removed with move")
        directoryWatcherEventManager?.addItemWasRemovedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                fileWasRemovedExpectation.fulfill()
            }
        })
        // Create new
        let fileWasCreatedExpectation = expectation(description: "File was created with move")
        directoryWatcherEventManager?.addFileWasCreatedOrModifiedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == destinationPath) {
                fileWasCreatedExpectation.fulfill()
            }
        })
        // Move
        SubprocessFileSystemModifier.moveItemAtPath(path, toPath: destinationPath)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
    func moveDirectoryAtPathWithConfirmation(path: String, destinationPath: String) {
        // Remove original
        let directoryWasRemovedExpectation = expectation(description: "Directory was removed with move")
        directoryWatcherEventManager?.addItemWasRemovedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == path) {
                directoryWasRemovedExpectation.fulfill()
            }
        })
        // Create new
        let directoryWasCreatedExpectation = expectation(description: "Directory was created with move")
        directoryWatcherEventManager?.addDirectoryWasCreatedOrModifiedAtPathHandler({ returnedPath -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(returnedPath as NSString) == destinationPath) {
                directoryWasCreatedExpectation.fulfill()
            }
        })
        // Move
        SubprocessFileSystemModifier.moveItemAtPath(path, toPath: destinationPath)
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
}

class WCLDirectoryWatcherDirectoryTests: WCLDirectoryWatcherTestCase {

    func testCreateWriteAndRemoveDirectory() {
        let testDirectoryPath = temporaryDirectoryURL.path.appendingPathComponent(testDirectoryName)
        let testFilePath = testDirectoryPath.appendingPathComponent(testFilename)

        // Test Create Directory
        createDirectoryAtPathWithConfirmation(testDirectoryPath)
        
        // Test Create File
        createFileAtPathWithConfirmation(testFilePath)

        // Test Modify File
        modifyFileAtPathWithConfirmation(testFilePath)

        // Test Remove File
        removeFileAtPathWithConfirmation(testFilePath)
        
        // Test Remove Directory
        removeDirectoryAtPathWithConfirmation(testDirectoryPath)

        // Test Create Directory Again
        createDirectoryAtPathWithConfirmation(testDirectoryPath)
        
        // Clean up

        // Test Remove Directory Again
        removeDirectoryAtPathWithConfirmation(testDirectoryPath)
    }

    func testMoveDirectory() {
        let testDirectoryPath = temporaryDirectoryURL.path.appendingPathComponent(testDirectoryName)
            
        // Test Create
        createDirectoryAtPathWithConfirmation(testDirectoryPath)

        // Test Move
        let testDirectoryPathTwo = testDirectoryPath.deletingLastPathComponent.appendingPathComponent(testDirectoryNameTwo)
        moveDirectoryAtPathWithConfirmation(testDirectoryPath, destinationPath: testDirectoryPathTwo)
        
        // Test Move Again
        moveDirectoryAtPathWithConfirmation(testDirectoryPathTwo, destinationPath: testDirectoryPath)

        // Clean up
            
        // Test Remove
        removeDirectoryAtPathWithConfirmation(testDirectoryPath)
    }

    func testMoveDirectoryContainingFile() {
        let testDirectoryPath = temporaryDirectoryURL.path.appendingPathComponent(testDirectoryName)
        let testFilePath = testDirectoryPath.appendingPathComponent(testFilename)

        // Test Create Directory
        createDirectoryAtPathWithConfirmation(testDirectoryPath)
        
        // Test Create File
        createFileAtPathWithConfirmation(testFilePath)
        
        // Test Move
        let testDirectoryPathTwo = testDirectoryPath.deletingLastPathComponent.appendingPathComponent(testDirectoryNameTwo)
        moveDirectoryAtPathWithConfirmation(testDirectoryPath, destinationPath: testDirectoryPathTwo)
        
        // Test Modify File
        let testFilePathTwo = testDirectoryPathTwo.appendingPathComponent(testFilename)
        modifyFileAtPathWithConfirmation(testFilePathTwo)
        
        // Test Move Again
        moveDirectoryAtPathWithConfirmation(testDirectoryPathTwo, destinationPath: testDirectoryPath)
        
        // Clean up

        // Test Remove File
        removeFileAtPathWithConfirmation(testFilePath)

        // Test Remove
        removeDirectoryAtPathWithConfirmation(testDirectoryPath)
    }

    func testReplaceDirectoryWithFile() {
        let testDirectoryPath = temporaryDirectoryURL.path.appendingPathComponent(testDirectoryName)
            
        // Test Create Directory
        createDirectoryAtPathWithConfirmation(testDirectoryPath)

        // Remove Directory
        removeDirectoryAtPathWithConfirmation(testDirectoryPath)
        
        // Test Create File
        createFileAtPathWithConfirmation(testDirectoryPath)

        // Remove File
        removeFileAtPathWithConfirmation(testDirectoryPath)
    }

    func testReplaceFileWithDirectory() {
        let testDirectoryPath = temporaryDirectoryURL.path.appendingPathComponent(testDirectoryName)
        
        // Test Create File
        createFileAtPathWithConfirmation(testDirectoryPath)
        
        // Remove File
        removeFileAtPathWithConfirmation(testDirectoryPath)
        
        // Test Create Directory
        createDirectoryAtPathWithConfirmation(testDirectoryPath)
        
        // Remove Directory
        removeDirectoryAtPathWithConfirmation(testDirectoryPath)
    }

}


class WCLDirectoryWatcherFileTests: WCLDirectoryWatcherTestCase {
    var testFilePath: String!
    
    override func setUp() {
        super.setUp()
        testFilePath = temporaryDirectoryURL.path.appendingPathComponent(testFilename)
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateWriteAndRemoveFile() {
        // Test Create
        createFileAtPathWithConfirmation(testFilePath)
        
        // Test Modify
        modifyFileAtPathWithConfirmation(testFilePath)
        
        // Test Remove
        removeFileAtPathWithConfirmation(testFilePath)

        // Test Create again
        createFileAtPathWithConfirmation(testFilePath)
        
        // Clean up

        // Test Remove again
        removeFileAtPathWithConfirmation(testFilePath)
    }

    func testMoveFile() {
        // Test Create With Write
        modifyFileAtPathWithConfirmation(testFilePath)

        // Test Move
        let testFilePathTwo = testFilePath.deletingLastPathComponent.appendingPathComponent(testFilenameTwo)
        moveFileAtPathWithConfirmation(testFilePath, destinationPath: testFilePathTwo)
        
        // Test Modify
        modifyFileAtPathWithConfirmation(testFilePathTwo)
        
        // Test Move Again
        moveFileAtPathWithConfirmation(testFilePathTwo, destinationPath: testFilePath)

        // Modify Again
        modifyFileAtPathWithConfirmation(testFilePath)
        
        // Clean up
            
        // Test Remove
        removeFileAtPathWithConfirmation(testFilePath)
    }
    
    func testFileManager() {
        // Test Create
        
        // Create expectation
        let fileWasCreatedOrModifiedExpectation = expectation(description: "File was created at \(testFilePath)")
        directoryWatcherEventManager?.addFileWasCreatedOrModifiedAtPathHandler({ path -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(path as NSString) ==  self.testFilePath) {
                fileWasCreatedOrModifiedExpectation.fulfill()
            }
        })
        
        // Test create a second file with NSFileManager
        let testFilePathTwo = testFilePath.deletingLastPathComponent.appendingPathComponent(testFilenameTwo)
        let contentsData = testFileContents.data(using: String.Encoding.utf8)
        FileManager.default.createFile(atPath: testFilePathTwo, contents: contentsData, attributes: nil)
        
        // Create file
        SubprocessFileSystemModifier.createFileAtPath(testFilePath)
        
        // Wait for expectation
        waitForExpectations(timeout: defaultTimeout, handler: nil)


        // Test Remove
        
        // Remove Expectation
        let fileWasRemovedExpectation = expectation(description: "File was removed")
        directoryWatcherEventManager?.addItemWasRemovedAtPathHandler({ path -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(path as NSString) ==  self.testFilePath) {
                fileWasRemovedExpectation.fulfill()
            }
        })
            
        // Test remove the second file with NSFileManager
        do {
            try FileManager.default.removeItem(atPath: testFilePathTwo)
        } catch {
            XCTAssertTrue(false, "The remove should succeed")
        }
        
        // Remove file
        SubprocessFileSystemModifier.removeFileAtPath(testFilePath)
        
        // Wait for expectation
        waitForExpectations(timeout: defaultTimeout, handler: nil)

    }
    
    func testFileManagerAsync() {

        
        // Test Create

        // Create expectation
        let fileWasCreatedOrModifiedExpectation = expectation(description: "File was created")
        directoryWatcherEventManager?.addFileWasCreatedOrModifiedAtPathHandler({ path -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(path as NSString) == self.testFilePath) {
                fileWasCreatedOrModifiedExpectation.fulfill()
            }
        })
            
        // Test create a second file with NSFileManager
        let testFilePathTwo = testFilePath.deletingLastPathComponent.appendingPathComponent(testFilenameTwo)
        let fileManagerCreateExpectation = expectation(description: "File manager created file")
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let contentsData = testFileContents.data(using: String.Encoding.utf8)
            FileManager.default.createFile(atPath: testFilePathTwo, contents: contentsData, attributes: nil)
            fileManagerCreateExpectation.fulfill()
        }
            
        // Create file
        SubprocessFileSystemModifier.createFileAtPath(testFilePath)
            
        // Wait for expectation
        waitForExpectations(timeout: defaultTimeout, handler: nil)
            
            
        // Test Remove
        
        // Remove Expectation
        let fileWasRemovedExpectation = expectation(description: "File was removed")
        directoryWatcherEventManager?.addItemWasRemovedAtPathHandler({ path -> Void in
            if (type(of: self).resolveTemporaryDirectoryPath(path as NSString) ==  self.testFilePath) {
                fileWasRemovedExpectation.fulfill()
            }
        })
        
        // Test remove the second file with NSFileManager
        let fileManagerRemoveExpectation = expectation(description: "File manager created file")
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            do {
                try FileManager.default.removeItem(atPath: testFilePathTwo)
            } catch {
                XCTAssertTrue(false, "The remove should succeed")
            }

            fileManagerRemoveExpectation.fulfill()
        }
        
        // Remove file
        SubprocessFileSystemModifier.removeFileAtPath(testFilePath)
        
        // Wait for expectation
        waitForExpectations(timeout: defaultTimeout, handler: nil)
    }
}
