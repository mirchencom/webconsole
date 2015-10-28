//
//  Plugin+Initialization.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/2/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//


extension Plugin {

    enum PluginLoadError: ErrorType {
        case InvalidBundleError(path: String)
        case InvalidInfoDictionaryError(URL: NSURL)
        case InvalidFileExtensionsError(infoDictionary: [NSObject : AnyObject])
        case InvalidCommandError(infoDictionary: [NSObject : AnyObject])
        case InvalidNameError(infoDictionary: [NSObject : AnyObject])
        case InvalidIdentifierError(infoDictionary: [NSObject : AnyObject])
        case InvalidHiddenError(infoDictionary: [NSObject : AnyObject])
        case InvalidEditableError(infoDictionary: [NSObject : AnyObject])
    }

    struct InfoDictionaryKeys {
        static let Name = "WCName"
        static let Identifier = "WCUUID"
        static let Command = "WCCommand"
        static let Suffixes = "WCFileExtensions"
        static let Hidden = "WCHidden"
        static let Editable = "WCEditable"
        static let DebugEnabled = "WCDebugModeEnabled"
    }

    enum PluginType {
        case BuiltIn, User, Other
        func name() -> String {
            switch self {
            case .BuiltIn:
                return "Built-In"
            case .User:
                return "User"
            case .Other:
                return "Other"
            }
        }
    }

    class func pluginWithURL(url: NSURL) -> Plugin? {
        if let path = url.path {
            return self.pluginWithPath(path)
        }
        return nil
    }

    class func pluginWithPath(path: String) -> Plugin? {
        do {
            let plugin = try validPluginWithPath(path)
            return plugin
        } catch PluginLoadError.InvalidBundleError(let path) {
            print("Bundle is invalid at path \(path).")
        } catch PluginLoadError.InvalidInfoDictionaryError(let URL) {
            print("Info.plist is invalid at URL \(URL).")
        } catch PluginLoadError.InvalidFileExtensionsError(let infoDictionary) {
            print("Plugin file extensions are invalid \(infoDictionary).")
        } catch PluginLoadError.InvalidCommandError(let infoDictionary) {
            print("Plugin command is invalid \(infoDictionary).")
        } catch PluginLoadError.InvalidNameError(let infoDictionary) {
            print("Plugin name is invalid \(infoDictionary).")
        } catch PluginLoadError.InvalidIdentifierError(let infoDictionary) {
            print("Plugin UUID is invalid \(infoDictionary).")
        } catch PluginLoadError.InvalidHiddenError(let infoDictionary) {
            print("Plugin hidden is invalid \(infoDictionary).")
        } catch PluginLoadError.InvalidEditableError(let infoDictionary) {
            print("Plugin editable is invalid \(infoDictionary).")
        } catch {
            print("Failed to load plugin at path \(path).")
        }
        
        return nil
    }
    
    class func validPluginWithPath(path: String) throws -> Plugin? {
        do {
            if let bundle = try validBundle(path),
                let infoDictionary = try validInfoDictionary(bundle),
                let identifier = try validIdentifier(infoDictionary),
                let name = try validName(infoDictionary)
            {
                // Optional Keys
                let pluginType = validPluginTypeFromPath(path)
                let command = try validCommand(infoDictionary)
                let suffixes = try validSuffixes(infoDictionary)
                let hidden = try validHidden(infoDictionary)
                let editable = try validEditable(infoDictionary)
                let debugEnabled = try validDebugEnabled(infoDictionary)
                

                // Plugin
                return Plugin(bundle: bundle,
                    infoDictionary: infoDictionary,
                    pluginType: pluginType,
                    identifier: identifier,
                    name: name,
                    command: command,
                    suffixes: suffixes,
                    hidden: hidden,
                    editable: editable,
                    debugEnabled: debugEnabled)

            }
        } catch let error as NSError {
            throw error
        }
        
        return nil
    }
    
    // MARK: Info Dictionary
    
    class func validBundle(path: String) throws -> NSBundle? {
        if let bundle = NSBundle(path: path) as NSBundle? {
            return bundle
        }

        throw PluginLoadError.InvalidBundleError(path: path)
    }
    
    class func validInfoDictionary(bundle: NSBundle) throws -> [NSObject : AnyObject]? {
        let URL = self.infoDictionaryURLForPluginURL(bundle.bundleURL)
        if let infoDictionary = NSDictionary(contentsOfURL: URL) {
            return infoDictionary as? [NSObject : AnyObject]
        }

        throw PluginLoadError.InvalidInfoDictionaryError(URL: URL)
    }

    class func validSuffixes(infoDictionary: [NSObject : AnyObject]) throws -> [String]? {
        if let suffixes = infoDictionary[InfoDictionaryKeys.Suffixes] as? [String] {
            return suffixes
        }

        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Suffixes] {
            // A missing suffixes is valid, but an existing malformed one is not
            throw PluginLoadError.InvalidFileExtensionsError(infoDictionary: infoDictionary)
        }

        return nil
    }

    class func validCommand(infoDictionary: [NSObject : AnyObject]) throws -> String? {
        if let command = infoDictionary[InfoDictionaryKeys.Command] as? String {
            if command.characters.count > 0 {
                return command
            }
        }

        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Command] {
            // A missing command is valid, but an existing malformed one is not
            throw PluginLoadError.InvalidCommandError(infoDictionary: infoDictionary)
        }

        return nil
    }
    
    class func validName(infoDictionary: [NSObject : AnyObject]) throws -> String? {
        if let name = infoDictionary[InfoDictionaryKeys.Name] as? String {
            if name.characters.count > 0 {
                return name
            }
        }
        
        throw PluginLoadError.InvalidNameError(infoDictionary: infoDictionary)
    }
    
    class func validIdentifier(infoDictionary: [NSObject : AnyObject]) throws -> String? {
        if let uuidString = infoDictionary[InfoDictionaryKeys.Identifier] as? String {
            let uuid: NSUUID? = NSUUID(UUIDString: uuidString)
            if uuid != nil {
                return uuidString
            }
        }

        throw PluginLoadError.InvalidIdentifierError(infoDictionary: infoDictionary)
    }

    class func validHidden(infoDictionary: [NSObject : AnyObject]) throws -> Bool {
        if let hidden = infoDictionary[InfoDictionaryKeys.Hidden] as? Int {
            return NSNumber(integer: hidden).boolValue
        }
        
        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Hidden] {
            // A missing hidden is valid, but an existing malformed one is not
            throw PluginLoadError.InvalidHiddenError(infoDictionary: infoDictionary)
        }

        return false
    }

    class func validEditable(infoDictionary: [NSObject : AnyObject]) throws -> Bool {
        if let editable = infoDictionary[InfoDictionaryKeys.Editable] as? Int {
            return NSNumber(integer: editable).boolValue
        }
        
        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Editable] {
            // A missing editable is valid, but an existing malformed one is not
            throw PluginLoadError.InvalidEditableError(infoDictionary: infoDictionary)
        }

        return true
    }

    class func validDebugEnabled(infoDictionary: [NSObject : AnyObject]) throws -> Bool {
        if let debugEnabled = infoDictionary[InfoDictionaryKeys.DebugEnabled] as? Int {
            return NSNumber(integer: debugEnabled).boolValue
        }
        
        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Editable] {
            // A missing editable is valid, but an existing malformed one is not
            throw PluginLoadError.InvalidEditableError(infoDictionary: infoDictionary)
        }
        
        return false
    }
    
    class func validPluginTypeFromPath(path: String) -> PluginType {
        let pluginContainerDirectory = path.stringByDeletingLastPathComponent
        switch pluginContainerDirectory {
        case Directory.ApplicationSupportPlugins.path():
            return PluginType.User
        case Directory.BuiltInPlugins.path():
            return PluginType.BuiltIn
        default:
            return PluginType.Other
        }
    }
}
