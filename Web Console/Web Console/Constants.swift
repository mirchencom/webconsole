//
//  Constants.swift
//  PluginManagerPrototype
//
//  Created by Roben Kleene on 9/13/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

let pluginFileExtension = "wcplugin"
let pluginNameKey = "name"
let applicationName = NSBundle.mainBundle().infoDictionary![kCFBundleNameKey as String] as! String
let errorDomain = NSBundle.mainBundle().bundleIdentifier!
let pluginsDirectoryPathComponent = "PlugIns"
let defaultNewPluginIdentifierKey = "WCLDefaultNewPluginIdentifier"
let debugModeEnabledKey = "WCLDebugModeEnabled"
let showLogMenuItemTitle = "Show Log"
let hideLogMenuItemTitle = "Hide Log"

let defaultFileExtensionEnabled = false
let initialDefaultNewPluginName = "HTML"
let sharedResourcesPluginName = "Shared Resources"
let logErrorPrefix = "ERROR "
let logMessagePrefix = "MESSAGE "

// MARK: User Defaults

let userDefaultsFilename = "UserDefaults"
let userDefaultsFileExtension = "plist"

// MARK: File System

enum Directory {
    case Caches
    case ApplicationSupport
    case ApplicationSupportPlugins
    case BuiltInPlugins
    case Trash
    func path() -> String {
        switch self {
        case .Caches:
            let cachesDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
            return cachesDirectory.stringByAppendingPathComponent(applicationName)
        case .ApplicationSupport:
            let applicationSupportDirectory = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0]
            return applicationSupportDirectory.stringByAppendingPathComponent(applicationName)
        case .ApplicationSupportPlugins:
            return Directory.ApplicationSupport.path().stringByAppendingPathComponent(pluginsDirectoryPathComponent)
        case .BuiltInPlugins:
            return NSBundle.mainBundle().builtInPlugInsPath!
        case .Trash:
            return NSSearchPathForDirectoriesInDomains(.TrashDirectory, .UserDomainMask, true)[0]
        }
    }
    func URL() -> NSURL {
        return NSURL(fileURLWithPath: self.path())
    }
}