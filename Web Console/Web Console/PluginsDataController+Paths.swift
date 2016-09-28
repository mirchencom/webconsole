//
//  PluginsDataController+Paths.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/2/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

extension PluginsDataController {
    class func pathsForPluginsAtPath(_ path: String) -> [String] {
        var pluginPaths = [String]()
        if let pathContents = try? FileManager.default.contentsOfDirectory(atPath: path) {
            let fileExtension = ".\(pluginFileExtension)"
            let pluginPredicate = NSPredicate(format: "self ENDSWITH %@", fileExtension)
            let pluginPathComponents = pathContents.filter {
                pluginPredicate.evaluate(with: $0)
            }
            for pluginPathComponent in pluginPathComponents {
                let pluginPath = path.stringByAppendingPathComponent(pluginPathComponent)
                pluginPaths.append(pluginPath)
            }
        }
        
        return pluginPaths
    }
    
    class func pluginsAtPluginPaths(_ pluginPaths: [String]) -> [Plugin] {
        var plugins = [Plugin]()
        for pluginPath in pluginPaths {
            if let plugin = Plugin.pluginWithPath(pluginPath) {
                plugins.append(plugin)
            }
        }
        return plugins
    }
    
    func pluginsAtPluginsPath(_ path: String) -> [Plugin] {
        let pluginPaths = type(of: self).pathsForPluginsAtPath(path)
        let plugins = type(of: self).pluginsAtPluginPaths(pluginPaths)
        return plugins
    }

}
