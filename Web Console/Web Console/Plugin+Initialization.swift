//
//  Plugin+Initialization.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/2/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//


extension Plugin {

    enum PluginLoadError: Error {
        case invalidBundleError(path: String)
        case invalidInfoDictionaryError(URL: URL)
        case invalidFileExtensionsError(infoDictionary: [AnyHashable: Any])
        case invalidCommandError(infoDictionary: [AnyHashable: Any])
        case invalidNameError(infoDictionary: [AnyHashable: Any])
        case invalidIdentifierError(infoDictionary: [AnyHashable: Any])
        case invalidHiddenError(infoDictionary: [AnyHashable: Any])
        case invalidEditableError(infoDictionary: [AnyHashable: Any])
        case invalidDebugModeEnabledError(infoDictionary: [AnyHashable: Any])
        
    }

    struct InfoDictionaryKeys {
        static let Name = "WCName"
        static let Identifier = "WCUUID"
        static let Command = "WCCommand"
        static let Suffixes = "WCFileExtensions"
        static let Hidden = "WCHidden"
        static let Editable = "WCEditable"
        static let DebugModeEnabled = "WCDebugModeEnabled"
    }

    enum PluginType {
        case builtIn, user, other
        func name() -> String {
            switch self {
            case .builtIn:
                return "Built-In"
            case .user:
                return "User"
            case .other:
                return "Other"
            }
        }
    }

    class func pluginWithURL(_ url: URL) -> Plugin? {
        if let path = url.path {
            return self.pluginWithPath(path)
        }
        return nil
    }

    class func pluginWithPath(_ path: String) -> Plugin? {
        do {
            let plugin = try validPluginWithPath(path)
            return plugin
        } catch PluginLoadError.invalidBundleError(let path) {
            print("Bundle is invalid at path \(path).")
        } catch PluginLoadError.invalidInfoDictionaryError(let URL) {
            print("Info.plist is invalid at URL \(URL).")
        } catch PluginLoadError.invalidFileExtensionsError(let infoDictionary) {
            print("Plugin file extensions are invalid \(infoDictionary).")
        } catch PluginLoadError.invalidCommandError(let infoDictionary) {
            print("Plugin command is invalid \(infoDictionary).")
        } catch PluginLoadError.invalidNameError(let infoDictionary) {
            print("Plugin name is invalid \(infoDictionary).")
        } catch PluginLoadError.invalidIdentifierError(let infoDictionary) {
            print("Plugin UUID is invalid \(infoDictionary).")
        } catch PluginLoadError.invalidHiddenError(let infoDictionary) {
            print("Plugin hidden is invalid \(infoDictionary).")
        } catch PluginLoadError.invalidEditableError(let infoDictionary) {
            print("Plugin editable is invalid \(infoDictionary).")
        } catch PluginLoadError.invalidDebugModeEnabledError(let infoDictionary) {
            print("Plugin debug mode enabled is invalid \(infoDictionary).")
        } catch {
            print("Failed to load plugin at path \(path).")
        }
        
        return nil
    }
    
    class func validPluginWithPath(_ path: String) throws -> Plugin? {
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
                let debugModeEnabled = try validDebugModeEnabled(infoDictionary)
                

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
                    debugModeEnabled: debugModeEnabled)

            }
        } catch let error as NSError {
            throw error
        }
        
        return nil
    }
    
    // MARK: Info Dictionary
    
    class func validBundle(_ path: String) throws -> Bundle? {
        if let bundle = Bundle(path: path) as Bundle? {
            return bundle
        }

        throw PluginLoadError.invalidBundleError(path: path)
    }
    
    class func validInfoDictionary(_ bundle: Bundle) throws -> [AnyHashable: Any]? {
        let URL = self.infoDictionaryURLForPluginURL(bundle.bundleURL)
        if let infoDictionary = NSDictionary(contentsOf: URL) {
            return infoDictionary as? [AnyHashable: Any]
        }

        throw PluginLoadError.invalidInfoDictionaryError(URL: URL)
    }

    class func validSuffixes(_ infoDictionary: [AnyHashable: Any]) throws -> [String]? {
        if let suffixes = infoDictionary[InfoDictionaryKeys.Suffixes] as? [String] {
            return suffixes
        }

        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Suffixes] as AnyObject? {
            // A missing suffixes is valid, but an existing malformed one is not
            throw PluginLoadError.invalidFileExtensionsError(infoDictionary: infoDictionary)
        }

        return nil
    }

    class func validCommand(_ infoDictionary: [AnyHashable: Any]) throws -> String? {
        if let command = infoDictionary[InfoDictionaryKeys.Command] as? String {
            if command.characters.count > 0 {
                return command
            }
        }

        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Command] as AnyObject? {
            // A missing command is valid, but an existing malformed one is not
            throw PluginLoadError.invalidCommandError(infoDictionary: infoDictionary)
        }

        return nil
    }
    
    class func validName(_ infoDictionary: [AnyHashable: Any]) throws -> String? {
        if let name = infoDictionary[InfoDictionaryKeys.Name] as? String {
            if name.characters.count > 0 {
                return name
            }
        }
        
        throw PluginLoadError.invalidNameError(infoDictionary: infoDictionary)
    }
    
    class func validIdentifier(_ infoDictionary: [AnyHashable: Any]) throws -> String? {
        if let uuidString = infoDictionary[InfoDictionaryKeys.Identifier] as? String {
            let uuid: UUID? = UUID(uuidString: uuidString)
            if uuid != nil {
                return uuidString
            }
        }

        throw PluginLoadError.invalidIdentifierError(infoDictionary: infoDictionary)
    }

    class func validHidden(_ infoDictionary: [AnyHashable: Any]) throws -> Bool {
        if let hidden = infoDictionary[InfoDictionaryKeys.Hidden] as? Int {
            return NSNumber(value: hidden as Int).boolValue
        }
        
        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Hidden] as AnyObject? {
            // A missing hidden is valid, but an existing malformed one is not
            throw PluginLoadError.invalidHiddenError(infoDictionary: infoDictionary)
        }

        return false
    }

    class func validEditable(_ infoDictionary: [AnyHashable: Any]) throws -> Bool {
        if let editable = infoDictionary[InfoDictionaryKeys.Editable] as? Int {
            return NSNumber(value: editable as Int).boolValue
        }
        
        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Editable] as AnyObject? {
            // A missing editable is valid, but an existing malformed one is not
            throw PluginLoadError.invalidEditableError(infoDictionary: infoDictionary)
        }

        return true
    }

    class func validDebugModeEnabled(_ infoDictionary: [AnyHashable: Any]) throws -> Bool? {
        if let debugModeEnabled = infoDictionary[InfoDictionaryKeys.DebugModeEnabled] as? Int {
            return NSNumber(value: debugModeEnabled as Int).boolValue
        }
        
        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.DebugModeEnabled] as AnyObject? {
            // A missing editable is valid, but an existing malformed one is not
            throw PluginLoadError.invalidDebugModeEnabledError(infoDictionary: infoDictionary)
        }
        
        return nil
    }
    
    class func validPluginTypeFromPath(_ path: String) -> PluginType {
        let pluginContainerDirectory = path.stringByDeletingLastPathComponent
        switch pluginContainerDirectory {
        case Directory.applicationSupportPlugins.path():
            return PluginType.user
        case Directory.builtInPlugins.path():
            return PluginType.builtIn
        default:
            return PluginType.other
        }
    }
}
