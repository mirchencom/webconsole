//
//  TemporaryDirectoryTestCase.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 9/25/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import XCTest


// TODO: Put this in the appropriate spot
// XCTAssert(false, "Attempted to delete a temporary item that is not in the temporary directory.")
// XCTAssert(false, "Attempted to delete a temporary item at a path that does not have the temporary directory path prefix.")

enum TemporaryDirectoryError: ErrorType {
    case NotInTemporaryDirectoryError(path: String)
    case InvalidURLError(URL: NSURL)
}

class TemporaryDirectoryTestCase: XCTestCase {
    var temporaryDirectoryPath: String!
    var temporaryDirectoryURL: NSURL! {
        get {
            return NSURL(fileURLWithPath:temporaryDirectoryPath)
        }
    }

    struct ClassConstants {
        static let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier!
        static let temporaryDirectoryPathPrefix = "/var/folders"
    }
    
    class func resolveTemporaryDirectoryPath(path: NSString) -> String {
        // Remove the "/private" path component because FSEvents returns paths iwth this prefix
        let testPathPrefix = "/private".stringByAppendingPathComponent(ClassConstants.temporaryDirectoryPathPrefix)
        let pathPrefixRange = path.rangeOfString(testPathPrefix)
        if pathPrefixRange.location == 0 {
            return path.stringByReplacingCharactersInRange(pathPrefixRange, withString: ClassConstants.temporaryDirectoryPathPrefix)
        }
        
        return path as String
    }
    
    class func isValidTemporaryDirectoryPath(path: String) -> Bool {
        var isDir: ObjCBool = false

        return NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir) && isDir
    }
    
    func removeTemporaryItemAtPathComponent(pathComponent: String) throws {
        let path = temporaryDirectoryPath.stringByAppendingPathComponent(pathComponent)
        do {
            try self.dynamicType.safelyRemoveTemporaryItemAtPath(path)
        } catch let error as NSError {
            throw error
        }
    }

    func removeTemporaryItemAtURL(URL: NSURL) throws {
        if let path = URL.path {
            do {
                try removeTemporaryItemAtPath(path)
            } catch let error as NSError {
                throw error
            }
        }
        throw TemporaryDirectoryError.InvalidURLError(URL: URL)
    }
    
    func removeTemporaryItemAtPath(path: String) throws {
        if !path.hasPrefix(temporaryDirectoryPath) {
            throw TemporaryDirectoryError.NotInTemporaryDirectoryError(path: path)
        }
        do {
            try self.dynamicType.safelyRemoveTemporaryItemAtPath(path)
        } catch let error as NSError {
            throw error
        }
    }
    
    private class func safelyRemoveTemporaryItemAtPath(path: String) throws {
        if !path.hasPrefix(ClassConstants.temporaryDirectoryPathPrefix) {
            throw TemporaryDirectoryError.NotInTemporaryDirectoryError(path: path)
        }
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch let error as NSError {
            throw error
        }
    }
    
    override func setUp() {
        super.setUp()

        if let temporaryDirectory = NSTemporaryDirectory() as String? {
            let identifierDirectoryPath = temporaryDirectory.stringByAppendingPathComponent(ClassConstants.bundleIdentifier)
            let path = identifierDirectoryPath.stringByAppendingPathComponent(className)
            if NSFileManager.defaultManager().fileExistsAtPath(path) {
                do {
                    try self.dynamicType.safelyRemoveTemporaryItemAtPath(path)
                } catch let error as NSError {
                    XCTAssertTrue(false, "Removing the temporary directory should have succeeded \(error)")
                }
                // This is not an assert in order to make it easier to fix tests that aren't cleaning up after themselves.
                print("Warning: A temporary directory had to be cleaned up at path \(path)")
            }
            XCTAssertFalse(NSFileManager.defaultManager().fileExistsAtPath(path), "A file should not exist at the path")
            do {
                try NSFileManager
                    .defaultManager()
                    .createDirectoryAtPath(path,
                        withIntermediateDirectories: true,
                        attributes: nil)
            } catch let error as NSError {
                XCTAssertNil(false ,"Creating the directory should succeed \(error)")
            }
            
            temporaryDirectoryPath = path
        }

        XCTAssertTrue(self.dynamicType.isValidTemporaryDirectoryPath(temporaryDirectoryPath), "The temporary directory path should be valid")
    }
    
    override func tearDown() {
        super.tearDown()
        
        XCTAssertTrue(self.dynamicType.isValidTemporaryDirectoryPath(temporaryDirectoryPath), "The temporary directory path should be valid")

        do {
            let contents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(temporaryDirectoryPath)
            if !contents.isEmpty {
                print("Warning: A temporary directory was not empty during tear down at path \(temporaryDirectoryPath)")
            }
            // This is an assert because it is evidence that a plugin isn't cleaning up after itself.
            // On next run the setup will clean it up, so the assert helps identify when a test isn't
            // cleaning up without hindering future runs.
            XCTAssert(contents.isEmpty, "The contents should be empty")

            // Remove the temporary directory
            try self.dynamicType.safelyRemoveTemporaryItemAtPath(temporaryDirectoryPath)
        } catch let error as NSError {
            XCTAssertTrue(false, "Failed to clean up a temporary directory \(error)")
        }

        // Confirm the temporary directory is removed
        XCTAssertFalse(self.dynamicType.isValidTemporaryDirectoryPath(temporaryDirectoryPath), "The temporary directory path should be invalid")
        XCTAssertFalse(NSFileManager.defaultManager().fileExistsAtPath(temporaryDirectoryPath), "A file should not exist at the path")
        temporaryDirectoryPath = nil
    }
}
