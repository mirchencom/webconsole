//
//  PluginManager.swift
//  PluginManagerPrototype
//
//  Created by Roben Kleene on 9/13/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Cocoa

class PluginsManager: WCLPluginsManager, PluginsDataControllerDelegate {
    
    let pluginsDataController: PluginsDataController
    
    // MARK: Singleton
    
    struct Singleton {
        static let instance: PluginsManager = PluginsManager()
        static var overrideSharedInstance: PluginsManager?
    }

    class var sharedInstance: PluginsManager {
        if let overrideSharedInstance = Singleton.overrideSharedInstance {
            return overrideSharedInstance
        }
        
        return Singleton.instance
    }

    class func setOverrideSharedInstance(_ pluginsManager: PluginsManager?) {
        Singleton.overrideSharedInstance = pluginsManager
    }

    // MARK: Init
    
    init(_ paths: [String], duplicatePluginDestinationDirectoryURL: URL) {
        self.pluginsDataController = PluginsDataController(paths, duplicatePluginDestinationDirectoryURL: duplicatePluginDestinationDirectoryURL)
        super.init(plugins: pluginsDataController.plugins())
        pluginsDataController.delegate = self
    }
    
    convenience override init() {
        self.init([Directory.builtInPlugins.path(), Directory.applicationSupportPlugins.path()], duplicatePluginDestinationDirectoryURL: Directory.applicationSupportPlugins.URL())
    }

    
    // MARK: Accessing Plugins
    
    func pluginWithName(_ name: String) -> Plugin? {
        return pluginsController.objectWithKey(name) as? Plugin
    }
    
    func pluginWithIdentifier(_ identifier: String) -> Plugin? {
        let allPlugins = plugins()
        for object: AnyObject in allPlugins {
            if let plugin: Plugin = object as? Plugin {
                if plugin.identifier == identifier {
                    return plugin
                }
            }
        }
        return nil
    }


    // MARK: Convenience
    
    func addUnwatchedPlugin(_ plugin: Plugin) {
        // TODO: For now this is a big hack, this adds a plugin that isn't managed by the PluginDataManager.
        // This means if the plugin moves on the file system for example, that the loaded plugin will be out-of-date.
        addPlugin(plugin)
    }
    
    fileprivate func addPlugin(_ plugin: Plugin) {
        insertObject(plugin, inPluginsAt: 0)
    }
    
    fileprivate func removePlugin(_ plugin: Plugin) {
        let index = pluginsController.indexOfObject(plugin)
        if index != NSNotFound {
            removeObjectFromPlugins(at: UInt(index))
        }
    }
    

    // MARK: Adding and Removing Plugins
    
    func movePluginToTrash(_ plugin: Plugin) {
        pluginsDataController.movePluginToTrash(plugin)
    }
    
    func duplicatePlugin(_ plugin: Plugin, handler: ((_ newPlugin: Plugin?, _ error: NSError?) -> Void)?) {
        pluginsDataController.duplicatePlugin(plugin, handler: handler)
    }

    func newPlugin(_ handler: ((_ newPlugin: Plugin?, _ error: NSError?) -> Void)?) {
        // May need to handle the case when no default new plugin is define in the future, but for now the fallback to the initial plugin should always work

        if let plugin = defaultNewPlugin {
            newPluginFromPlugin(plugin, handler: handler)
        }
    }

    func newPluginFromPlugin(_ plugin: Plugin, handler: ((_ newPlugin: Plugin?, _ error: NSError?) -> Void)?) {
        duplicatePlugin(plugin, handler: handler)
    }


    
    // MARK: PluginsDataControllerDelegate

    func pluginsDataController(_ pluginsDataController: PluginsDataController, didAddPlugin plugin: Plugin) {
        addPlugin(plugin)
    }


    func pluginsDataController(_ pluginsDataController: PluginsDataController, didRemovePlugin plugin: Plugin) {
        if let unwrappedDefaultNewPlugin = defaultNewPlugin {
            if unwrappedDefaultNewPlugin == plugin {
                defaultNewPlugin = nil
            }
        }
        removePlugin(plugin)
    }


    // MARK: Shared Resources

    func sharedResourcesPath() -> String? {
        let plugin = pluginWithName(sharedResourcesPluginName)
        return plugin?.resourcePath
    }

    func sharedResourcesURL() -> URL? {
        let plugin = pluginWithName(sharedResourcesPluginName)
        return plugin?.resourceURL as URL?
    }
}
