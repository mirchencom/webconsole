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
            NSWorkspace.shared().openFile(resourcePath)
        }
    }
}


class Plugin: WCLPlugin {
    enum PluginWriteError: Error {
        case failToWriteDictionaryError(URL: URL)
    }
    
    struct ClassConstants {
        static let infoDictionaryPathComponent = "Contents".stringByAppendingPathComponent("Info.plist")
    }
    internal let bundle: Bundle
    let hidden: Bool
    let debugModeEnabled: Bool?
    let pluginType: PluginType
    
    init(bundle: Bundle,
        infoDictionary: [AnyHashable: Any],
        pluginType: PluginType,
        identifier: String,
        name: String,
        command: String?,
        suffixes: [String]?,
        hidden: Bool,
        editable: Bool,
        debugModeEnabled: Bool?)
    {
        self.infoDictionary = infoDictionary
        self.pluginType = pluginType
        self.bundle = bundle
        self.name = name
        self.identifier = identifier
        self.hidden = hidden
        self.editable = editable
        self.debugModeEnabled = debugModeEnabled
        
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
    var resourceURL: URL? {
        if let path = resourcePath {
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    internal var infoDictionary: [AnyHashable: Any]
    internal var infoDictionaryURL: URL {
        get {
            return type(of: self).infoDictionaryURLForPluginURL(bundle.bundleURL)
        }
    }

    class func infoDictionaryURLForPlugin(_ plugin: Plugin) -> URL {
        return infoDictionaryURLForPluginURL(plugin.bundle.bundleURL)
    }

    class func infoDictionaryURLForPluginURL(_ pluginURL: URL) -> URL {
        return pluginURL.appendingPathComponent(ClassConstants.infoDictionaryPathComponent)
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
    
    fileprivate func save() {
        let infoDictionaryURL = self.infoDictionaryURL
        do {
            try type(of: self).writeDictionary(infoDictionary, toURL: infoDictionaryURL)
        } catch PluginWriteError.failToWriteDictionaryError(let URL) {
            print("Failed to write an info dictionary at URL \(URL)")
        } catch let error as NSError {
            print("Failed to write an info dictionary \(error)")
        }

    }

    class func writeDictionary(_ dictionary: [AnyHashable: Any], toURL URL: Foundation.URL) throws {
        let writableDictionary = NSDictionary(dictionary: dictionary)
        let success = writableDictionary.write(to: URL, atomically: true)
        if !success {
            throw PluginWriteError.failToWriteDictionaryError(URL: URL)
        }
    }

    // MARK: Description
    
    override var description : String {
        let description = super.description
        return "\(description), Plugin name = \(name),  identifier = \(identifier), defaultNewPlugin = \(isDefaultNewPlugin), hidden = \(hidden), editable = \(editable), debugModeEnabled = \(debugModeEnabled)"
    }
    
    // MARK: Windows

    func orderedWindows() -> [AnyObject]! {
        return WCLSplitWebWindowsController.shared().windows(for: self) as [AnyObject]!
    }

}
