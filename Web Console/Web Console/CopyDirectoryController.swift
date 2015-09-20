
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
        self.cleanUp()
    }
    

    // MARK: Public
    
    func cleanUp() {
        self.dynamicType.moveContentsOfURL(copyTempDirectoryURL, toDirectoryInTrashWithName: trashDirectoryName)
    }
    
    func copyItemAtURL(URL: NSURL, completionHandler handler: (URL: NSURL?) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let copiedURL = self.dynamicType.URLOfItemCopiedFromURL(URL, toDirectoryURL: self.copyTempDirectoryURL)
            dispatch_async(dispatch_get_main_queue()) {
                handler(URL: copiedURL)
                if let path = copiedURL?.path {
                    let fileExists = NSFileManager.defaultManager().fileExistsAtPath(path)
                    assert(!fileExists, "The file should not exist")
                } else {
                    assert(false, "Getting the path should succeed")
                }
            }
        }
    }
    

    // MARK: Private Clean Up Helpers

    class func moveContentsOfURL(URL: NSURL, toDirectoryInTrashWithName trashDirectoryName: String) {
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
                } catch {
                    assert(false, "The error should be nil")
                }
                
                if let filename = filename as? String {
                    if filename == trashDirectoryName {
                        continue
                    }

                    let trashDirectoryURL = URL.URLByAppendingPathComponent(trashDirectoryName)
                    if !foundFilesToRecover {
                        createDirectoryIfMissingAtURL(trashDirectoryURL)
                        foundFilesToRecover = true
                    }
                    
                    let UUID = NSUUID()
                    let UUIDString = UUID.UUIDString
                    let destinationFileURL = trashDirectoryURL.URLByAppendingPathComponent(UUIDString)
                    do {
                        try NSFileManager.defaultManager().moveItemAtURL(fileURL, toURL: destinationFileURL)
                    } catch {
                        assert(false, "The move should succeed")
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
    
    private class func URLOfItemCopiedFromURL(URL: NSURL, toDirectoryURL directoryURL: NSURL) -> NSURL? {
        // TODO: Improve error handling

        // Setup the destination directory
        createDirectoryIfMissingAtURL(directoryURL)
        
        let uuid = NSUUID()
        let uuidString = uuid.UUIDString
        let destinationURL = directoryURL.URLByAppendingPathComponent(uuidString)

        do {
            try NSFileManager.defaultManager().copyItemAtURL(URL, toURL: destinationURL)
            return destinationURL
        } catch {
            // TODO: Improve error handling here, this might happen if the user's disk is full for example
            assert(false, "The copy should succeed")
        }

        return nil
    }


    // MARK: Private Create Directory Helpers
    
    private class func createDirectoryIfMissingAtPath(path: String) {
        // TODO: Should set error instead of assert
        var isDir: ObjCBool = false
        let exists = NSFileManager.defaultManager()
            .fileExistsAtPath(path,
                isDirectory: &isDir)
        
        if exists {
            let success = isDir ? true : false
            assert(success, "The file should be a directory")
            return
        }
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            // TODO: Improve error handling here, this might happen if the user's disk is full for example
            assert(false, "The create should succeed")
        }
    }
    
    private class func createDirectoryIfMissingAtURL(URL: NSURL) {
        if let path = URL.path {
            createDirectoryIfMissingAtPath(path)
        }
        
        assert(false, "Getting the path should succeed")
    }
}