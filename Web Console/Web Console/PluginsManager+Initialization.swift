//
//  PluginManager+Initialization.swift
//  Web Console
//
//  Created by Roben Kleene on 5/7/17.
//  Copyright © 2017 Roben Kleene. All rights reserved.
//

import Foundation

extension PluginsManager {

    class func setOverrideSharedInstance(_ pluginsManager: PluginsManager?) {
        Singleton.overrideSharedInstance = pluginsManager
    }

    class var sharedInstance: PluginsManager {
        if let overrideSharedInstance = Singleton.overrideSharedInstance {
            return overrideSharedInstance
        }
        
        return Singleton.instance
    }
    
    struct Singleton {
        static let instance: PluginsManager = PluginsManager()
        static var overrideSharedInstance: PluginsManager?
    }

    
    convenience override init() {
        self.init(paths: [Directory.builtInPlugins.path(),
                          Directory.applicationSupportPlugins.path()],
                  duplicatePluginDestinationDirectoryURL: Directory.applicationSupportPlugins.URL()
            copyTempDirectoryURL: Directory.caches.URL()
            builtInPluginsPath: Directory.builtInPlugins.path(),
            applicationSupportPluginsPath: Directory.applicationSupportPlugins.path())
    }
}
