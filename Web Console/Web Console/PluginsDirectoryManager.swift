//
//  PluginsDirectoryManager.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 11/8/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Foundation

protocol PluginsDirectoryManagerDelegate {
    func pluginsDirectoryManager(pluginsDirectoryManager: PluginsDirectoryManager, pluginInfoDictionaryWasCreatedOrModifiedAt pluginPath: String)
    func pluginsDirectoryManager(pluginsDirectoryManager: PluginsDirectoryManager, pluginInfoDictionaryWasRemovedAt pluginPath: String)
}

class PluginsPathHelper {

    class func subpathRange(inPath path: String, untilSubpath subpath: String) -> NSRange {
        // Normalize the subpath so the same range is always returned regardless of the format of the subpath (e.g., number of slashes)
        let normalizedSubpath = subpath.standardizingPath
        

        let pathAsNSString: NSString = path as NSString
        let subpathRange = pathAsNSString.range(of: normalizedSubpath)
        if subpathRange.location == NSNotFound {
            return subpathRange
        }
        let untilSubpathLength = subpathRange.location + subpathRange.length
        let untilSubpathRange = NSRange(location: 0, length: untilSubpathLength)
        return untilSubpathRange
    }
    
    class func subpath(from path: String, until subpath: String) -> String? {
        let range = subpathRange(inPath:path, untilSubpath: subpath)
        if (range.location == NSNotFound) {
            return nil
        }
        let pathAsNSString: NSString = path as NSString
        let pathUntilSubpath = pathAsNSString.substring(with: range)
        return pathUntilSubpath
    }
    
    class func pathComponents(ofPath path: String, afterSubpath subpath: String) -> [String]? {
        let normalizedPath = path.standardizingPath
        let range = subpathRange(inPath:normalizedPath, untilSubpath: subpath)
        if range.location == NSNotFound {
            return nil
        }

        let normalizedPathAsNSString: NSString = normalizedPath as NSString
        let pathComponent = normalizedPathAsNSString.substring(from: range.length)
        let pathComponents = pathComponent.pathComponents

        if pathComponents.count == 0 {
            return pathComponents
        }

        // Remove slashes (path components are sometimes slashes for the first and last component)
        let mutablePathComponents = NSMutableArray(array: pathComponents)
        mutablePathComponents.remove("/")
        return mutablePathComponents as NSArray as? [String]
    }

    class func contains(_ pathComponent: String, subpathComponent: String) -> Bool {
        let pathComponents = pathComponent.pathComponents
        let subpathComponents = subpathComponent.pathComponents
        for index in 0..<subpathComponents.count {
            let pathComponent = pathComponents[index] as NSString
            let subpathComponent = subpathComponents[index]
            if !pathComponent.isEqual(to: subpathComponent) {
                return false
            }
        }
        return true
    }
    
    class func does(pathComponent: String, match matchPathComponent: String) -> Bool {
        let pathComponents = pathComponent.pathComponents
        let matchPathComponents = matchPathComponent.pathComponents
        if pathComponents.count != matchPathComponents.count {
            return false
        }
        for index in 0..<pathComponents.count {
            let pathComponent = pathComponents[index] as NSString
            let matchPathComponent = matchPathComponents[index]
            if !pathComponent.isEqual(to: matchPathComponent) {
                return false
            }
        }
        return true
    }
    
    class func path(path: String, containsSubpath subpathComponent: String) -> Bool {
        if let pathUntilSubpath = subpath(from: path, until: subpath) {
            return pathUntilSubpath.standardizingPath == subpath.standardizingPath
        }
        return false
    }
}

class PluginsDirectoryManager: NSObject, WCLDirectoryWatcherDelegate, PluginsDirectoryEventHandlerDelegate {
    struct ClassConstants {
        static let infoDictionaryPathComponent = "Contents/Info.plist"
    }
    var delegate: PluginsDirectoryManagerDelegate?
    let pluginsDirectoryEventHandler: PluginsDirectoryEventHandler
    let directoryWatcher: WCLDirectoryWatcher
    let pluginsDirectoryURL: URL
    init(pluginsDirectoryURL: URL) {
        self.pluginsDirectoryURL = pluginsDirectoryURL
        self.directoryWatcher = WCLDirectoryWatcher(url: pluginsDirectoryURL)
        self.pluginsDirectoryEventHandler = PluginsDirectoryEventHandler()

        super.init()
        self.directoryWatcher.delegate = self
        self.pluginsDirectoryEventHandler.delegate = self
    }

    // MARK: WCLDirectoryWatcherDelegate
    
    func directoryWatcher(_ directoryWatcher: WCLDirectoryWatcher, directoryWasCreatedOrModifiedAtPath path: String) {
        assert(isSubpathOfPluginsDirectory(path: path), "The path should be a subpath of the plugins directory")

        if let pluginPath = pluginPath(fromPath: path) {
            pluginsDirectoryEventHandler.addDirectoryWasCreatedOrModifiedEvent(at: pluginPath, path: path)
        }
    }

    func directoryWatcher(_ directoryWatcher: WCLDirectoryWatcher, fileWasCreatedOrModifiedAtPath path: String) {
        assert(isSubpathOfPluginsDirectory(path: path), "The path should be a subpath of the plugins directory")
    
        if let pluginPath = pluginPath(fromPath: path) {
            pluginsDirectoryEventHandler.addFileWasCreatedOrModifiedEvent(at: pluginPath, path: path)
        }
    }

    func directoryWatcher(_ directoryWatcher: WCLDirectoryWatcher, itemWasRemovedAtPath path: String) {
        assert(isSubpathOfPluginsDirectory(path: path), "The path should be a subpath of the plugins directory")
        
        if let pluginPath = pluginPath(fromPath: path) {
            pluginsDirectoryEventHandler.addItemWasRemovedEvent(at: pluginPath, path: path)
        }
    }

    
    // MARK: PluginsDirectoryEventHandlerDelegate

    func pluginsDirectoryEventHandler(_ pluginsDirectoryEventHandler: PluginsDirectoryEventHandler,
        handleCreatedOrModifiedEventsAtPluginPath pluginPath: String,
        createdOrModifiedDirectoryPaths directoryPaths: [String]?,
        createdOrModifiedFilePaths filePaths: [String]?)
    {
        if let filePaths = filePaths {
            for path in filePaths {

                if shouldFireInfoDictionaryWasCreatedOrModified(at: pluginPath,
                    forFileCreatedOrModifiedAtPath: path)
                {
                    delegate?.pluginsDirectoryManager(self, pluginInfoDictionaryWasCreatedOrModifiedAt: pluginPath)
                    return
                }
                
            }
        }

        if let directoryPaths = directoryPaths {
            for path in directoryPaths {
                if shouldFireInfoDictionaryWasCreatedOrModified(at: pluginPath,
                    forDirectoryCreatedOrModifiedAtPath: path)
                {
                    delegate?.pluginsDirectoryManager(self, pluginInfoDictionaryWasCreatedOrModifiedAt: pluginPath)
                    return
                }
            }
        }
    }

    func pluginsDirectoryEventHandler(_ pluginsDirectoryEventHandler: PluginsDirectoryEventHandler,
        handleRemovedEventsAtPluginPath pluginPath: String,
        removedItemPaths itemPaths: [String]?)
    {
        if let itemPaths = itemPaths {
            for path in itemPaths {
                if shouldFireInfoDictionaryWasRemoved(at: pluginPath,
                    forItemRemovedAt: path)
                {
                    delegate?.pluginsDirectoryManager(self, pluginInfoDictionaryWasRemovedAtPluginPath: pluginPath)
                    return
                }
            }
        }
    }

    
    // MARK: Evaluating Events

    func shouldFireInfoDictionaryWasCreatedOrModified(at pluginPath: String,
        forDirectoryCreatedOrModifiedAtPath path: String) -> Bool
    {
        if containsValidInfoDictionarySubpath(path) {
            if doesInfoDictionaryExist(at: pluginPath) {
                return true
            }
        }
        return false
    }

    func shouldFireInfoDictionaryWasCreatedOrModified(at pluginPath: String,
        forFileCreatedOrModifiedAtPath path: String) -> Bool
    {
        if isValidInfoDictionary(at: path) {
            if doesInfoDictionaryExist(at: pluginPath) {
                return true
            }
        }
        return false
    }

    func shouldFireInfoDictionaryWasRemoved(at pluginPath: String,
        forItemRemovedAt path: String) -> Bool
    {
        if containsValidInfoDictionarySubpath(path) {
            if !doesInfoDictionaryExist(at: pluginPath) {
                return true
            }
        }
        return false
    }

    
    // MARK: Helpers

    func isValidInfoDictionary(at path: String) -> Bool {
        return hasValidInfoDictionarySubpath(path, requireExactInfoDictionaryMatch: true)
    }

    func containsValidInfoDictionarySubpath(_ path: String) -> Bool {
        return hasValidInfoDictionarySubpath(path, requireExactInfoDictionaryMatch: false)
    }
    
    func hasValidInfoDictionarySubpath(_ path: String, requireExactInfoDictionaryMatch: Bool) -> Bool {
        if let pluginPathComponents = pluginPathComponents(from: path) {
            var pluginSubpathComponents = pluginPathComponents as? [String]
            if let firstPathComponent = pluginSubpathComponents?.remove(at: 0) {
                if firstPathComponent.pathExtension != pluginFileExtension {
                    return false
                }

                if let pluginSubpathComponents = pluginSubpathComponents {
                    let pluginSubpath = NSString.path(withComponents: pluginSubpathComponents)
                    
                    if requireExactInfoDictionaryMatch {
                        return PluginsPathHelper.does(ClassConstants.infoDictionaryPathComponent, match: pluginSubpath)
                    } else {
                        return PluginsPathHelper.contains(ClassConstants.infoDictionaryPathComponent, subpathComponent: pluginSubpath)
                    }
                }
            }
            
        }
        return false
    }

    func doesInfoDictionaryExist(at pluginPath: String) -> Bool {
        let infoDictionaryPath = pluginPath.appendingPathComponent(ClassConstants.infoDictionaryPathComponent)
        var isDir: ObjCBool = false
        let fileExists = FileManager.default.fileExists(atPath: infoDictionaryPath, isDirectory: &isDir)
        return fileExists && !isDir.boolValue
    }
    
    func infoDictionaryIsSubdirectoryOfPath(path: String) -> Bool {
        return false
    }

    func pluginPath(fromPath path: String) -> String? {
        if let pluginPathComponent = pluginPathComponent(from: path) {
            let pluginPath = pluginsDirectoryURL.path.appendingPathComponent(pluginPathComponent)
            return pluginPath
        }
        return nil
    }
    
    func pluginPathComponent(from path: String) -> String? {
        if let pathComponents = PluginsPathHelper.pathComponents(ofPath: path, afterSubpath: pluginsDirectoryURL.path) {
            if (pathComponents.count > 0) {
                var pluginSubpathComponents = pathComponents as Array
                let pathComponent = pluginSubpathComponents[0]
                return pathComponent
            }
        }
        return nil
    }

    func pluginPathComponents(from path: String) -> NSArray? {
            let pathComponents = PluginsPathHelper.pathComponents(ofPath: path, afterSubpath: pluginsDirectoryURL.path)
            return pathComponents as NSArray?
    }
    
    func isSubpathOfPluginsDirectory(path: String) -> Bool {
        return PluginsPathHelper.path(path, containsSubpath: pluginsDirectoryURL.path)
    }
    
}
