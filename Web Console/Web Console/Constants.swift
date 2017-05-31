//
//  Constants.swift
//  PluginManagerPrototype
//
//  Created by Roben Kleene on 9/13/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

let applicationName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
let pluginsDirectoryPathComponent = "PlugIns"
let debugModeEnabledKey = kDebugModeEnabledKey
let runningProcessesKey = "WCLRunningProcesses"
let showLogMenuItemTitle = "Show Log"
let hideLogMenuItemTitle = "Hide Log"

let defaultFileExtensionEnabled = false
let logErrorPrefix = "ERROR "
let logMessagePrefix = "MESSAGE "

// MARK: User Defaults

let userDefaultsFilename = kUserDefaultsFilename
let userDefaultsFileExtension = kUserDefaultsFileExtension

// MARK: File System

enum Directory {
    case caches
    case applicationSupport
    case applicationSupportPlugins
    case builtInPlugins
    case trash
    func path() -> String {
        switch self {
        case .caches:
            let cachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            return cachesDirectory.appendingPathComponent(applicationName)
        case .applicationSupport:
            let applicationSupportDirectory = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0]
            return applicationSupportDirectory.appendingPathComponent(applicationName)
        case .applicationSupportPlugins:
            return Directory.applicationSupport.path().appendingPathComponent(pluginsDirectoryPathComponent)
        case .builtInPlugins:
            return Bundle.main.builtInPlugInsPath!
        case .trash:
            return NSSearchPathForDirectoriesInDomains(.trashDirectory, .userDomainMask, true)[0]
        }
    }
    func URL() -> Foundation.URL {
        return Foundation.URL(fileURLWithPath: self.path())
    }
}
