//
//  CopyDirectoryControllerTests.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/4/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Cocoa
import XCTest

@testable import Web_Console

class CopyDirectoryControllerTests: TemporaryPluginsTestCase {
    var copyDirectoryController: CopyDirectoryController!
    struct ClassConstants {
        static let tempDirectoryName = "Copy Directory Test"
    }
    
    override func setUp() {
        super.setUp()
        copyDirectoryController = CopyDirectoryController(tempDirectoryName: ClassConstants.tempDirectoryName)
    }
    
    override func tearDown() {
        copyDirectoryController = nil
        super.tearDown()
    }

    
    func testCopy() {
        let copyExpectation = expectationWithDescription("Copy")
        
        var copiedPluginURL: NSURL!
        copyDirectoryController.copyItemAtURL(pluginURL, completionHandler: { (URL, error) -> Void in
            XCTAssertNotNil(URL, "The URL should not be nil")
            XCTAssertNil(error, "The error should be nil")
            
            if let URL = URL {
                let movedFilename = testDirectoryName
                let movedDestinationURL = self.pluginsDirectoryURL.URLByAppendingPathComponent(movedFilename)

                do {
                    try NSFileManager.defaultManager().moveItemAtURL(URL,
                        toURL: movedDestinationURL)
                } catch {
                    XCTAssertTrue(false, "The move should succeed")
                }

                copiedPluginURL = movedDestinationURL
                copyExpectation.fulfill()
            }
        })
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)

        var isDir: ObjCBool = false
        let exists = NSFileManager.defaultManager().fileExistsAtPath(copiedPluginURL.path!,
            isDirectory: &isDir)
        XCTAssertTrue(exists, "The item should exist")
        XCTAssertTrue(isDir, "The item should be a directory")

        let pluginInfoDictionaryURL = Plugin.infoDictionaryURLForPluginURL(pluginURL)
        let copiedPluginInfoDictionaryURL = Plugin.infoDictionaryURLForPluginURL(copiedPluginURL)
        
        do {
            let pluginInfoDictionaryContents: String! = try String(contentsOfURL: pluginInfoDictionaryURL, encoding: NSUTF8StringEncoding)
            let copiedPluginInfoDictionaryContents: String! = try String(contentsOfURL: copiedPluginInfoDictionaryURL, encoding: NSUTF8StringEncoding)
            XCTAssertEqual(copiedPluginInfoDictionaryContents, pluginInfoDictionaryContents, "The contents should be equal")
        } catch {
            XCTAssertTrue(false, "Getting the info dictionary contents should succeed")
        }
        
        // Cleanup
        do {
            try removeTemporaryItemAtURL(copiedPluginURL)
        } catch {
            XCTAssertTrue(false, "The remove should succeed")
        }
    }

    func testCleanUpOnInit() {
        let copyExpectation = expectationWithDescription("Copy")
        copyDirectoryController.copyItemAtURL(pluginURL, completionHandler: { (URL, error) -> Void in
            XCTAssertNotNil(URL, "The URL should not be nil")
            XCTAssertNil(error, "The error should be nil")

            if let URL = URL {
                let movedFilename = testDirectoryName
                let movedDirectoryURL: NSURL! = URL.URLByDeletingLastPathComponent
                let movedDestinationURL = movedDirectoryURL.URLByAppendingPathComponent(movedFilename)

                do {
                    try NSFileManager.defaultManager().moveItemAtURL(URL,
                        toURL: movedDestinationURL)
                } catch {
                    XCTAssertTrue(false, "The move should succeed")
                }

                copyExpectation.fulfill()
            }
        })
        waitForExpectationsWithTimeout(defaultTimeout, handler: nil)

        // Assert the contents is empty
        do {
            let contents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(copyDirectoryController.copyTempDirectoryURL,
                includingPropertiesForKeys: [NSURLNameKey],
                options: [.SkipsHiddenFiles, .SkipsSubdirectoryDescendants])
            XCTAssertFalse(contents.isEmpty, "The contents should not be empty")
        } catch {
            XCTAssertTrue(false, "Getting the contents should succeed")
        }

        // Init a new CopyDirectoryController
        let copyDirectoryControllerTwo = CopyDirectoryController(tempDirectoryName: ClassConstants.tempDirectoryName)
        
        // Assert directory is empty

        do {
            let contentsTwo = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(copyDirectoryController.copyTempDirectoryURL,
                includingPropertiesForKeys: [NSURLNameKey],
                options: [.SkipsHiddenFiles, .SkipsSubdirectoryDescendants])
            XCTAssertTrue(contentsTwo.isEmpty, "The contents should be empty")
        } catch {
            XCTAssertTrue(false, "Getting the contents should succeed")
        }

        // Clean Up
        let recoveredFilesPath = Directory.Trash.path().stringByAppendingPathComponent(copyDirectoryControllerTwo.trashDirectoryName)
        var isDir: ObjCBool = false
        let exists = NSFileManager.defaultManager().fileExistsAtPath(recoveredFilesPath, isDirectory: &isDir)
        XCTAssertTrue(exists, "The item should exist")
        XCTAssertTrue(isDir, "The item should be a directory")

        // Clean up trash
        do {
            try NSFileManager.defaultManager().removeItemAtPath(recoveredFilesPath)
        } catch {
            XCTAssertTrue(false, "The remove should succeed")
        }
    }
}
