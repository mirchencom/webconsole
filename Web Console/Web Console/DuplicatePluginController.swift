//
//  DuplicatePluginController.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 9/25/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Foundation

class DuplicatePluginController {
    lazy var copyDirectoryController = CopyDirectoryController(tempDirectoryName: ClassConstants.tempDirectoryName)

    struct ClassConstants {
        static let tempDirectoryName = "Duplicate Plugin"
    }
    class func pluginFilenameFromName(name: String) -> String {
        return name.stringByAppendingPathExtension(pluginFileExtension)!
    }
    func duplicatePlugin(plugin: Plugin, toDirectoryAtURL destinationDirectoryURL: NSURL, completionHandler handler: (plugin: Plugin?, error: NSError?) -> Void) {
        let pluginFileURL = plugin.bundle.bundleURL
        copyDirectoryController.copyItemAtURL(pluginFileURL, completionHandler: { (URL, error) -> Void in
            
            guard error == nil else {
                handler(plugin: nil, error: error)
                return
            }
            
            var plugin: Plugin?
            if let URL = URL {
                let UUID = NSUUID()
                let movedFilename = self.dynamicType.pluginFilenameFromName(UUID.UUIDString)
                let movedDestinationURL = destinationDirectoryURL.URLByAppendingPathComponent(movedFilename)
                
                
                do {
                    try NSFileManager.defaultManager().moveItemAtURL(URL, toURL: movedDestinationURL)
                } catch let error as NSError {
                    handler(plugin: nil, error: error)
                }
                
                if let movedPlugin = Plugin.pluginWithURL(movedDestinationURL) {
                    movedPlugin.editable = true
                    movedPlugin.renameWithUniqueName()
                    movedPlugin.identifier = UUID.UUIDString
                    plugin = movedPlugin
                    
                    // Attempt to move the plugin to a directory based on its name (this can safely fail)
                    let renamedPluginFilename = self.dynamicType.pluginFilenameFromName(movedPlugin.name)
                    let renamedDestinationURL = movedDestinationURL.URLByDeletingLastPathComponent!.URLByAppendingPathComponent(renamedPluginFilename)
                    do {
                        try NSFileManager.defaultManager().moveItemAtURL(movedDestinationURL, toURL: renamedDestinationURL)
                    } catch let error as NSError {
                        handler(plugin: nil, error: error)
                    }
                    
                    if let renamedPlugin = Plugin.pluginWithURL(renamedDestinationURL) {
                        plugin = renamedPlugin
                    }
                }
            }

            handler(plugin: plugin, error: error)
        })
    }
}