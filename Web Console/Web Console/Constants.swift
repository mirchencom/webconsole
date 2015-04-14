//
//  Constants.swift
//  PluginManagerPrototype
//
//  Created by Roben Kleene on 9/13/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

let pluginFileExtension = "wcplugin"
let pluginNameKey = "name"
let applicationName = NSBundle.mainBundle().infoDictionary![kCFBundleNameKey as NSString] as! String
let errorDomain = NSBundle.mainBundle().bundleIdentifier!
let pluginsDirectoryPathComponent = "PlugIns"
let defaultNewPluginIdentifierKey = "WCLDefaultNewPluginIdentifier"
let defaultFileExtensionEnabled = false
let initialDefaultNewPluginName = "HTML"
let sharedResourcesPluginName = "Shared Resources"

enum Directory {
    case Caches
    case ApplicationSupport
    case ApplicationSupportPlugins
    case BuiltInPlugins
    case Trash
    func path() -> String {
        switch self {
        case .Caches:
            let cachesDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as! String
            return cachesDirectory.stringByAppendingPathComponent(applicationName)
        case .ApplicationSupport:
            let applicationSupportDirectory = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0]as! NSString
            return applicationSupportDirectory.stringByAppendingPathComponent(applicationName)
        case .ApplicationSupportPlugins:
            return Directory.ApplicationSupport.path().stringByAppendingPathComponent(pluginsDirectoryPathComponent)
        case .BuiltInPlugins:
            return NSBundle.mainBundle().builtInPlugInsPath!
        case .Trash:
            return NSSearchPathForDirectoriesInDomains(.TrashDirectory, .UserDomainMask, true)[0] as! String
        }
    }
    func URL() -> NSURL {
        return NSURL(fileURLWithPath: self.path())!
    }
}