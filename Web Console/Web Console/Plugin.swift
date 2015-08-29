//
//  Plugin.swift
//  PluginManagerPrototype
//
//  Created by Roben Kleene on 9/13/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Cocoa

extension Plugin {
    func open() {
        assert(editable, "The plugin should be editable")
        if !editable {
            return
        }
        if let resourcePath = resourcePath {
            NSWorkspace.sharedWorkspace().openFile(resourcePath)
        }
    }
}


class Plugin: WCLPlugin {
    struct ClassConstants {
        static let errorCode = -43
        static let infoDictionaryPathComponent = "Contents".stringByAppendingPathComponent("Info.plist")
    }
    internal let bundle: NSBundle
    let hidden: Bool
    let pluginType: PluginType
    
    init(bundle: NSBundle,
        infoDictionary: [NSObject : AnyObject],
        pluginType: PluginType,
        identifier: String,
        name: String,
        command: String?,
        suffixes: [String]?,
        hidden: Bool,
        editable: Bool)
    {
        self.infoDictionary = infoDictionary
        self.bundle = bundle
        self.name = name
        self.identifier = identifier
        self.hidden = hidden
        self.editable = editable
        self.pluginType = pluginType
        
        // Optional
        self.command = command
        self.suffixes = [String]()
        if let suffixes = suffixes {
            self.suffixes += suffixes
        }
    }
    
    // MARK: Paths

    var resourcePath: String? {
        return bundle.resourcePath
    }
    var resourceURL: NSURL? {
        if let path = resourcePath {
            return NSURL.fileURLWithPath(path)
        }
        return nil
    }
    internal var infoDictionary: [NSObject : AnyObject]
    internal var infoDictionaryURL: NSURL {
        get {
            return self.dynamicType.infoDictionaryURLForPluginURL(bundle.bundleURL)
        }
    }

    class func infoDictionaryURLForPlugin(plugin: Plugin) -> NSURL {
        return infoDictionaryURLForPluginURL(plugin.bundle.bundleURL)
    }

    class func infoDictionaryURLForPluginURL(pluginURL: NSURL) -> NSURL {
        return pluginURL.URLByAppendingPathComponent(ClassConstants.infoDictionaryPathComponent)
    }
    
    
    // MARK: Properties
    
    dynamic var name: String {
        willSet {
            assert(editable, "The plugin should be editable")
        }
        didSet {
            infoDictionary[InfoDictionaryKeys.Name] = name
            save()
        }
    }
    var identifier: String {
        willSet {
            assert(editable, "The plugin should be editable")
        }
        didSet {
            infoDictionary[InfoDictionaryKeys.Identifier] = identifier
            save()
        }
    }
    dynamic var command: String? {
        willSet {
            assert(editable, "The plugin should be editable")
        }
        didSet {
            infoDictionary[InfoDictionaryKeys.Command] = command
            save()
        }
    }
    var commandPath: String? {
        get {
            if let resourcePath = resourcePath {
                if let command = command {
                    return resourcePath.stringByAppendingPathComponent(command)
                }
            }
            return nil
        }
    }
    dynamic var suffixes: [String] {
        willSet {
            assert(editable, "The plugin should be editable")
        }
        didSet {
            infoDictionary[InfoDictionaryKeys.Suffixes] = suffixes
            save()
        }
    }
    dynamic var type: String {
        return pluginType.name()
    }
    dynamic var editable: Bool {
        didSet {
            if (!editable) {
                infoDictionary[InfoDictionaryKeys.Editable] = editable
            } else {
                infoDictionary[InfoDictionaryKeys.Editable] = nil
            }
            save()
        }
    }
    
    // MARK: Save
    
    private func save() {
        let infoDictionaryURL = self.infoDictionaryURL
        var error: NSError?
        self.dynamicType.writeDictionary(infoDictionary, toURL: infoDictionaryURL, error: &error)
    }
    class func writeDictionary(dictionary: [NSObject : AnyObject], toURL url: NSURL, error: NSErrorPointer) {
        let writableDictionary = NSDictionary(dictionary: dictionary)
        let success = writableDictionary.writeToURL(url, atomically: true)
        if !success && error != nil {
            if let path = url.path {
                let errorString = NSLocalizedString("Failed to write to dictionary at path \(path).", comment: "Failed to write to dictionary")
                error.memory = NSError.errorWithDescription(errorString, code: ClassConstants.errorCode)
            }
        }
    }

    // MARK: Description
    
    override var description : String {
        let description = super.description
        return "\(description), Plugin name = \(name),  identifier = \(identifier), defaultNewPlugin = \(defaultNewPlugin), hidden = \(hidden), editable = \(editable)"
    }

    // MARK: Running
    
    func runWithArguments(arguments: [AnyObject]!, inDirectoryPath directoryPath: String!) {
        self.runCommandPath(commandPath, withArguments: arguments, inDirectoryPath: directoryPath)
    }

    func runCommandPath(commandPath: String!, withArguments arguments: [AnyObject]?, inDirectoryPath directoryPath: String?) {
        println("runCommandPath:\(commandPath) withArguments:\(arguments) inDirectoryPath:\(directoryPath)")
        let task = NSTask()
        task.launchPath = commandPath
        if let directoryPath = directoryPath {
            task.currentDirectoryPath = directoryPath
        }
        if let arguments = arguments {
            task.arguments = arguments
        }

        let splitWebWindowController = WCLSplitWebWindowsController.sharedSplitWebWindowsController().addedSplitWebWindowControllerForPlugin(self)

        // TODO: Refactor this to support log plugin
        splitWebWindowController.runTask(task)
    }
    
    // MARK: Windows

    func orderedWindows() -> [AnyObject]! {
        return WCLSplitWebWindowsController.sharedSplitWebWindowsController().windowsForPlugin(self)
    }

}
