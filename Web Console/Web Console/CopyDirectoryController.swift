
//
//  DirectoryDuplicateController.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/4/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Foundation
import Cocoa

class CopyDirectoryController {
    let copyTempDirectoryURL: NSURL
    let tempDirectoryName: String
    var trashDirectoryName: String {
        get {
            return tempDirectoryName + " Recovered"
        }
    }
    
    init(tempDirectoryName: String) {
        self.tempDirectoryName = tempDirectoryName
        self.copyTempDirectoryURL = Directory.Caches.URL().URLByAppendingPathComponent(tempDirectoryName)
        do {
            try self.cleanUp()
        } catch let error as NSError {
            assert(false, "Failed to clean up \(error)")
        }
    }
    

    // MARK: Public
    
    func cleanUp() throws {
        do {
            try self.dynamicType.moveContentsOfURL(copyTempDirectoryURL, toDirectoryInTrashWithName: trashDirectoryName)
        } catch let error as NSError {
            throw error
        }
    }
    
    func copyItemAtURL(URL: NSURL, completionHandler handler: (URL: NSURL?, error: NSError?) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            do {
                let copiedURL = try self.dynamicType.URLOfItemCopiedFromURL(URL, toDirectoryURL: self.copyTempDirectoryURL)
                dispatch_async(dispatch_get_main_queue()) {
                    handler(URL: copiedURL, error: nil)
                    if let path = copiedURL?.path {
                        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(path)
                        assert(!fileExists, "The file should not exist")
                    } else {
                        assert(false, "Getting the path should succeed")
                    }
                }
            } catch let error as NSError {
                handler(URL: nil, error: error)
            }
        }
    }
    

    // MARK: Private Clean Up Helpers

    class func moveContentsOfURL(URL: NSURL, toDirectoryInTrashWithName trashDirectoryName: String) throws {
        var validCachesURL = false
        if let path = URL.path {
            let hasPrefix = path.hasPrefix(Directory.Caches.path())
            validCachesURL = hasPrefix
        }
        if !validCachesURL {
            assert(false, "The URL should be a valid caches URL")
            return
        }

        var foundFilesToRecover = false
        if let enumerator = NSFileManager.defaultManager().enumeratorAtURL(URL,
            includingPropertiesForKeys: [NSURLNameKey],
            options: [.SkipsHiddenFiles, .SkipsSubdirectoryDescendants],
            errorHandler: nil)
        {
            while let fileURL = enumerator.nextObject() as? NSURL {
                
                var filename: AnyObject?
                do {
                    try fileURL.getResourceValue(&filename, forKey: NSURLNameKey)
                } catch let error as NSError {
                    throw error
                }
                
                if let filename = filename as? String {
                    if filename == trashDirectoryName {
                        continue
                    }

                    let trashDirectoryURL = URL.URLByAppendingPathComponent(trashDirectoryName)
                    if !foundFilesToRecover {
                        do {
                            try createDirectoryIfMissingAtURL(trashDirectoryURL)
                        } catch let error as NSError {
                            throw error
                        }
                        
                        foundFilesToRecover = true
                    }
                    
                    let UUID = NSUUID()
                    let UUIDString = UUID.UUIDString
                    let destinationFileURL = trashDirectoryURL.URLByAppendingPathComponent(UUIDString)
                    do {
                        try NSFileManager.defaultManager().moveItemAtURL(fileURL, toURL: destinationFileURL)
                    } catch let error as NSError {
                        throw error
                    }
                }
            }
        }

        if !foundFilesToRecover {
            return
        }

        if let path = URL.path {
            NSWorkspace.sharedWorkspace().performFileOperation(NSWorkspaceRecycleOperation,
                source: path,
                destination: "",
                files: [trashDirectoryName],
                tag: nil)
        } else {
            assert(false, "Getting the path should succeed")
        }
    }
    

    // MARK: Private Duplicate Helpers
    
    private class func URLOfItemCopiedFromURL(URL: NSURL, toDirectoryURL directoryURL: NSURL) throws -> NSURL? {
        do {
            // Setup the destination directory
            try createDirectoryIfMissingAtURL(directoryURL)
        } catch let error as NSError {
            throw error
        }
        
        let uuid = NSUUID()
        let uuidString = uuid.UUIDString
        let destinationURL = directoryURL.URLByAppendingPathComponent(uuidString)

        do {
            try NSFileManager.defaultManager().copyItemAtURL(URL, toURL: destinationURL)
            return destinationURL
        } catch let error as NSError {
            throw error
        }
    }


    // MARK: Private Create Directory Helpers
    
    private class func createDirectoryIfMissingAtPath(path: String) throws {
        // TODO: Should set error instead of assert
        var isDir: ObjCBool = false
        let exists = NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir)

        if exists {
            if !isDir {
                throw FileSystemError.FileExistsForDirectoryError
            }
            return
        }
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            throw error
        }
    }
    
    private class func createDirectoryIfMissingAtURL(URL: NSURL) throws {
        if let path = URL.path {
            do {
                try createDirectoryIfMissingAtPath(path)
            } catch let error as NSError {
                throw error
            }
        } else {
            assert(false, "Getting the path should succeed")
        }
    }
}