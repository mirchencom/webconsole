//
//  PluginManager.swift
//  PluginManagerPrototype
//
//  Created by Roben Kleene on 9/13/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Cocoa

protocol PluginsDataControllerDelegate {
    func pluginsDataController(pluginsDataController: PluginsDataController, didAddPlugin plugin: Plugin)
    func pluginsDataController(pluginsDataController: PluginsDataController, didRemovePlugin plugin: Plugin)
}

class PluginsDataController: PluginsDirectoryManagerDelegate {

    var delegate: PluginsDataControllerDelegate?
    var pluginDirectoryManagers: [PluginsDirectoryManager]!
    var pluginPathToPluginDictionary: [String : Plugin]!
    lazy var duplicatePluginController = DuplicatePluginController()
    let duplicatePluginDestinationDirectoryURL: URL
    
    init(paths: [String], duplicatePluginDestinationDirectoryURL: URL) {
        self.pluginDirectoryManagers = [PluginsDirectoryManager]()
        self.pluginPathToPluginDictionary = [String : Plugin]()
        self.duplicatePluginDestinationDirectoryURL = duplicatePluginDestinationDirectoryURL
        
        for path in paths {
            let plugins = self.pluginsAtPluginsPath(path)
            for plugin in plugins {
                pluginPathToPluginDictionary[plugin.bundle.bundlePath] = plugin
            }
            let pluginsDirectoryURL = URL(fileURLWithPath: path)
            let pluginDirectoryManager = PluginsDirectoryManager(pluginsDirectoryURL: pluginsDirectoryURL)
            pluginDirectoryManager.delegate = self
            pluginDirectoryManagers.append(pluginDirectoryManager)
        }
    }


    // MARK: Plugins
    
    func plugins() -> [Plugin] {
        return Array(pluginPathToPluginDictionary.values)
    }
    

    // MARK: PluginsDirectoryManagerDelegate

    func pluginsDirectoryManager(pluginsDirectoryManager: PluginsDirectoryManager,
        pluginInfoDictionaryWasCreatedOrModifiedAtPluginPath pluginPath: String)
    {
        if let oldPlugin = pluginAtPluginPath(pluginPath) {
            if let newPlugin = Plugin.makePlugin(path: pluginPath) {
                // If there is an existing plugin and a new plugin, remove the old plugin and add the new plugin
                if !oldPlugin.isEqualToPlugin(newPlugin) {
                    removePlugin(oldPlugin)
                    addPlugin(newPlugin)
                }
            }
        } else {
            // If there is only a new plugin, add it
            if let newPlugin = Plugin.makePlugin(path: pluginPath) {
                addPlugin(newPlugin)
            }
        }
    }
    
    func pluginsDirectoryManager(pluginsDirectoryManager: PluginsDirectoryManager,
        pluginInfoDictionaryWasRemovedAtPluginPath pluginPath: String)
    {
        if let oldPlugin = pluginAtPluginPath(pluginPath) {
            removePlugin(oldPlugin)
        }
    }

    
    // MARK: Add & Remove Helpers
    
    func addPlugin(plugin: Plugin) {
        let pluginPath = plugin.bundle.bundlePath
        pluginPathToPluginDictionary[pluginPath] = plugin
        delegate?.pluginsDataController(self, didAddPlugin: plugin)
    }
    
    func removePlugin(plugin: Plugin) {
        let pluginPath = plugin.bundle.bundlePath
        pluginPathToPluginDictionary.removeValue(forKey: pluginPath)
        delegate?.pluginsDataController(self, didRemovePlugin: plugin)
    }
    
    func pluginAtPluginPath(pluginPath: String) -> Plugin? {
        return pluginPathToPluginDictionary[pluginPath]
    }


    // MARK: Duplicate and Remove

    func moveToTrash(_ plugin: Plugin) {
        assert(plugin.editable, "The plugin should be editable")
        removePlugin(plugin)
        let pluginPath = plugin.bundle.bundlePath
        let pluginDirectoryPath = pluginPath.deletingLastPathComponent
        let pluginDirectoryName = pluginPath.lastPathComponent
        NSWorkspace.shared().performFileOperation(NSWorkspaceRecycleOperation,
            source: pluginDirectoryPath,
            destination: "",
            files: [pluginDirectoryName],
            tag: nil)
        let exists = FileManager.default.fileExists(atPath: pluginPath)
        assert(!exists, "The file should not exist")
    }
    
    func duplicatePlugin(plugin: Plugin, handler: ((_ plugin: Plugin?, _ error: NSError?) -> Void)?) {

        do {
            try type(of: self).createDirectoryIfMissing(duplicatePluginDestinationDirectoryURL)
        } catch let error as NSError {
            handler?(nil, error)
            return
        }

        duplicatePluginController.duplicatePlugin(plugin,
            toDirectoryAtURL: duplicatePluginDestinationDirectoryURL)
        { (plugin, error) -> Void in
            if let plugin = plugin {
                self.addPlugin(plugin)
            }
            handler?(plugin, error)
        }
    }

    class func createDirectoryIfMissing(directoryURL: URL) throws {
        var isDir: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: &isDir)
        if (exists && isDir.boolValue) {
            return
        }
        
        if (exists && !isDir.boolValue) {
            throw FileSystemError.fileExistsForDirectoryError
        }

        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            throw error
        }
    }
    
}
