//
//  PluginsDirectoryManager.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 11/8/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Foundation

protocol PluginsDirectoryManagerDelegate {
    func pluginsDirectoryManager(_ pluginsDirectoryManager: PluginsDirectoryManager, pluginInfoDictionaryWasCreatedOrModifiedAtPluginPath pluginPath: String)
    func pluginsDirectoryManager(_ pluginsDirectoryManager: PluginsDirectoryManager, pluginInfoDictionaryWasRemovedAtPluginPath pluginPath: String)
}

class PluginsPathHelper {

    class func rangeInPath(_ path: String, untilSubpath subpath: String) -> NSRange {
        // Normalize the subpath so the same range is always returned regardless of the format of the subpath (e.g., number of slashes)
        let normalizedSubpath = subpath.stringByStandardizingPath
        

        let pathAsNSString: NSString = path as NSString
        let subpathRange = pathAsNSString.range(of: normalizedSubpath)
        if subpathRange.location == NSNotFound {
            return subpathRange
        }
        let untilSubpathLength = subpathRange.location + subpathRange.length
        let untilSubpathRange = NSRange(location: 0, length: untilSubpathLength)
        return untilSubpathRange
    }
    
    class func subpathFromPath(_ path: String, untilSubpath subpath: String) -> String? {
        let range = rangeInPath(path, untilSubpath: subpath)
        if (range.location == NSNotFound) {
            return nil
        }
        let pathAsNSString: NSString = path as NSString
        let pathUntilSubpath = pathAsNSString.substring(with: range)
        return pathUntilSubpath
    }
    
    class func pathComponentsOfPath(_ path: String, afterSubpath subpath: String) -> [String]? {
        let normalizedPath = path.stringByStandardizingPath
        let range = rangeInPath(normalizedPath, untilSubpath: subpath)
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

    class func pathComponent(_ pathComponent: String, containsSubpathComponent subpathComponent: String) -> Bool {
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
    
    class func pathComponent(_ pathComponent: String, isPathComponent matchPathComponent: String) -> Bool {
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
    
    class func path(_ path: String, containsSubpath subpath: String) -> Bool {
        if let pathUntilSubpath = subpathFromPath(path, untilSubpath: subpath) {
            return pathUntilSubpath.stringByStandardizingPath == subpath.stringByStandardizingPath
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
    
    func directoryWatcher(_ directoryWatcher: WCLDirectoryWatcher!, directoryWasCreatedOrModifiedAtPath path: String!) {
        assert(pathIsSubpathOfPluginsDirectory(path), "The path should be a subpath of the plugins directory")

        if let pluginPath = pluginPathFromPath(path) {
            pluginsDirectoryEventHandler.addDirectoryWasCreatedOrModifiedEventAtPluginPath(pluginPath, path: path)
        }
    }

    func directoryWatcher(_ directoryWatcher: WCLDirectoryWatcher!, fileWasCreatedOrModifiedAtPath path: String!) {
        assert(pathIsSubpathOfPluginsDirectory(path), "The path should be a subpath of the plugins directory")
    
        if let pluginPath = pluginPathFromPath(path) {
            pluginsDirectoryEventHandler.addFileWasCreatedOrModifiedEventAtPluginPath(pluginPath, path: path)
        }
    }

    func directoryWatcher(_ directoryWatcher: WCLDirectoryWatcher!, itemWasRemovedAtPath path: String!) {
        assert(pathIsSubpathOfPluginsDirectory(path), "The path should be a subpath of the plugins directory")
        
        if let pluginPath = pluginPathFromPath(path) {
            pluginsDirectoryEventHandler.addItemWasRemovedAtPluginPath(pluginPath, path: path)
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

                if shouldFireInfoDictionaryWasCreatedOrModifiedAtPluginPath(pluginPath,
                    forFileCreatedOrModifiedAtPath: path)
                {
                    delegate?.pluginsDirectoryManager(self, pluginInfoDictionaryWasCreatedOrModifiedAtPluginPath: pluginPath)
                    return
                }
                
            }
        }

        if let directoryPaths = directoryPaths {
            for path in directoryPaths {
                if shouldFireInfoDictionaryWasCreatedOrModifiedAtPluginPath(pluginPath,
                    forDirectoryCreatedOrModifiedAtPath: path)
                {
                    delegate?.pluginsDirectoryManager(self, pluginInfoDictionaryWasCreatedOrModifiedAtPluginPath: pluginPath)
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
                if shouldFireInfoDictionaryWasRemovedAtPluginPath(pluginPath,
                    forItemRemovedAtPath: path)
                {
                    delegate?.pluginsDirectoryManager(self, pluginInfoDictionaryWasRemovedAtPluginPath: pluginPath)
                    return
                }
            }
        }
    }

    
    // MARK: Evaluating Events

    func shouldFireInfoDictionaryWasCreatedOrModifiedAtPluginPath(_ pluginPath: String,
        forDirectoryCreatedOrModifiedAtPath path: String) -> Bool
    {
        if pathContainsValidInfoDictionarySubpath(path) {
            if infoDictionaryExistsAtPluginPath(pluginPath) {
                return true
            }
        }
        return false
    }

    func shouldFireInfoDictionaryWasCreatedOrModifiedAtPluginPath(_ pluginPath: String,
        forFileCreatedOrModifiedAtPath path: String) -> Bool
    {
        if pathIsValidInfoDictionaryPath(path) {
            if infoDictionaryExistsAtPluginPath(pluginPath) {
                return true
            }
        }
        return false
    }

    func shouldFireInfoDictionaryWasRemovedAtPluginPath(_ pluginPath: String,
        forItemRemovedAtPath path: String) -> Bool
    {
        if pathContainsValidInfoDictionarySubpath(path) {
            if !infoDictionaryExistsAtPluginPath(pluginPath) {
                return true
            }
        }
        return false
    }

    
    // MARK: Helpers

    func pathIsValidInfoDictionaryPath(_ path: String) -> Bool {
        return pathHasValidInfoDictionarySubpath(path, requireExactInfoDictionaryMatch: true)
    }

    func pathContainsValidInfoDictionarySubpath(_ path: String) -> Bool {
        return pathHasValidInfoDictionarySubpath(path, requireExactInfoDictionaryMatch: false)
    }
    
    func pathHasValidInfoDictionarySubpath(_ path: String, requireExactInfoDictionaryMatch: Bool) -> Bool {
        if let pluginPathComponents = pluginPathComponentsFromPath(path) {
            var pluginSubpathComponents = pluginPathComponents as? [String]
            if let firstPathComponent = pluginSubpathComponents?.remove(at: 0) {
                if firstPathComponent.pathExtension != pluginFileExtension {
                    return false
                }

                if let pluginSubpathComponents = pluginSubpathComponents {
                    let pluginSubpath = NSString.path(withComponents: pluginSubpathComponents)
                    
                    if requireExactInfoDictionaryMatch {
                        return PluginsPathHelper.pathComponent(ClassConstants.infoDictionaryPathComponent, isPathComponent: pluginSubpath)
                    } else {
                        return PluginsPathHelper.pathComponent(ClassConstants.infoDictionaryPathComponent, containsSubpathComponent: pluginSubpath)
                    }
                }
            }
            
        }
        return false
    }

    func infoDictionaryExistsAtPluginPath(_ pluginPath: String) -> Bool {
        let infoDictionaryPath = pluginPath.stringByAppendingPathComponent(ClassConstants.infoDictionaryPathComponent)
        var isDir: ObjCBool = false
        let fileExists = FileManager.default.fileExists(atPath: infoDictionaryPath, isDirectory: &isDir)
        return fileExists && !isDir
    }
    
    func infoDictionaryIsSubdirectoryOfPath(_ path: String) -> Bool {
        return false
    }

    func pluginPathFromPath(_ path: String) -> String? {
        if let pluginPathComponent = pluginPathComponentFromPath(path) {
            if let subpath = pluginsDirectoryURL.path {
                let pluginPath = subpath.stringByAppendingPathComponent(pluginPathComponent)
                return pluginPath
            }
        }
        return nil
    }
    
    func pluginPathComponentFromPath(_ path: String) -> String? {
        if let subpath = pluginsDirectoryURL.path {
            if let pathComponents = PluginsPathHelper.pathComponentsOfPath(path, afterSubpath: subpath) {
                if (pathComponents.count > 0) {
                    var pluginSubpathComponents = pathComponents as Array
                    let pathComponent = pluginSubpathComponents[0]
                    return pathComponent
                }
            }
        }
        return nil
    }

    func pluginPathComponentsFromPath(_ path: String) -> NSArray? {
        if let subpath = pluginsDirectoryURL.path {
            let pathComponents = PluginsPathHelper.pathComponentsOfPath(path, afterSubpath: subpath)
            return pathComponents
        }
        return nil
    }
    
    func pathIsSubpathOfPluginsDirectory(_ path: String) -> Bool {
        if let subpath = pluginsDirectoryURL.path {
            return PluginsPathHelper.path(path, containsSubpath: subpath)
        }
        return false
    }
    
}
