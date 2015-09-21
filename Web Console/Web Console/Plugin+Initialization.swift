//
//  Plugin+Initialization.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 1/2/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//


extension Plugin {
    struct InfoDictionaryKeys {
        static let Name = "WCName"
        static let Identifier = "WCUUID"
        static let Command = "WCCommand"
        static let Suffixes = "WCFileExtensions"
        static let Hidden = "WCHidden"
        static let Editable = "WCEditable"
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
    
    class func pluginWithURL(url: NSURL) -> Plugin? {
        if let path = url.path {
            return self.pluginWithPath2(path)
        }
        return nil
    }

    class func pluginWithPath2(path: String) -> Plugin? {
        do {
            let plugin = try pluginWithPath(path)
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
    }
    
    class func pluginWithPath(path: String) throws -> Plugin? {
        do {
            let bundle = try validBundle(path)
        } catch let error as NSError {
            throw error
        }
        
        
        var error: NSError?
        if let bundle = validBundle(path, error: &error) {
            if let infoDictionary = validInfoDictionary(bundle, error: &error) {
                if let identifier = validIdentifier(infoDictionary, error: &error) {
                    if let name = validName(infoDictionary, error: &error) {
    
                        // Optional Keys
                        let command = validCommand(infoDictionary, error: &error) // Can be nil
                        if error == nil {
                            let suffixes = validSuffixes(infoDictionary, error: &error) // Can be nil
                            if error == nil {
                                let hidden = validHidden(infoDictionary, error: &error)
                                if error == nil {
                                    let editable = validEditable(infoDictionary, error: &error)
                                    if error == nil {
                                        let pluginType = validPluginTypeFromPath(path)
                                        return Plugin(bundle: bundle,
                                            infoDictionary: infoDictionary,
                                            pluginType: pluginType,
                                            identifier: identifier,
                                            name: name,
                                            command: command,
                                            suffixes: suffixes,
                                            hidden: hidden,
                                            editable: editable)
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }
        
        print("Failed to load a plugin at path \(path) \(error)")
        return nil
    }
    
    // MARK: Info Dictionary
    
    class func validBundle(path: String) throws -> NSBundle? {
        if let bundle = NSBundle(path: path) as NSBundle? {
            return bundle
        }
        throw PluginLoadError.InvalidBundleError(path: path)
    }
    
    class func validInfoDictionary(bundle: NSBundle, error: NSErrorPointer) throws -> [NSObject : AnyObject]? {
        let URL = self.infoDictionaryURLForPluginURL(bundle.bundleURL)

        if let infoDictionary = NSDictionary(contentsOfURL: URL) {
            return infoDictionary as? [NSObject : AnyObject]
        }
        throw PluginLoadError.InvalidInfoDictionaryError(URL: URL)
    }

    class func validSuffixes(infoDictionary: [NSObject : AnyObject], error: NSErrorPointer) throws -> [String]? {
        if let suffixes = infoDictionary[InfoDictionaryKeys.Suffixes] as? [String] {
            return suffixes
        }

        throw PluginLoadError.InvalidFileExtensionsError(infoDictionary: infoDictionary)
    }

    class func validCommand(infoDictionary: [NSObject : AnyObject], error: NSErrorPointer) -> String? {
        if let command = infoDictionary[InfoDictionaryKeys.Command] as? String {
            if command.characters.count > 0 {
                return command
            }
        }

        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Command] {
            if error != nil {
                let errorString = NSLocalizedString("Plugin command is invalid \(infoDictionary).", comment: "Invalid plugin command error")
                error.memory = NSError.errorWithDescription(errorString, code: ClassConstants.errorCode)
            }
        }
        
        return nil
    }
    
    class func validName(infoDictionary: [NSObject : AnyObject], error: NSErrorPointer) -> String? {
        if let name = infoDictionary[InfoDictionaryKeys.Name] as? String {
            if name.characters.count > 0 {
                return name
            }
        }
        
        if error != nil {
            let errorString = NSLocalizedString("Plugin name is invalid \(infoDictionary).", comment: "Invalid plugin name error")
            error.memory = NSError.errorWithDescription(errorString, code: ClassConstants.errorCode)
        }
        
        return nil
    }
    
    class func validIdentifier(infoDictionary: [NSObject : AnyObject], error: NSErrorPointer) -> String? {
        if let uuidString = infoDictionary[InfoDictionaryKeys.Identifier] as? String {
            let uuid: NSUUID? = NSUUID(UUIDString: uuidString)
            if uuid != nil {
                return uuidString
            }
        }
        
        if error != nil {
            let errorString = NSLocalizedString("Plugin UUID is invalid \(infoDictionary).", comment: "Invalid plugin UUID error")
            error.memory = NSError.errorWithDescription(errorString, code: ClassConstants.errorCode)
        }
        
        return nil
    }

    class func validHidden(infoDictionary: [NSObject : AnyObject], error: NSErrorPointer) -> Bool {
        if let hidden = infoDictionary[InfoDictionaryKeys.Hidden] as? Int {
            return NSNumber(integer: hidden).boolValue
        }
        
        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Hidden] {
            if error != nil {
                let errorString = NSLocalizedString("Plugin hidden is invalid \(infoDictionary).", comment: "Invalid plugin name error")
                error.memory = NSError.errorWithDescription(errorString, code: ClassConstants.errorCode)
            }
        }

        return false
    }

    class func validEditable(infoDictionary: [NSObject : AnyObject], error: NSErrorPointer) -> Bool {
        if let editable = infoDictionary[InfoDictionaryKeys.Editable] as? Int {
            return NSNumber(integer: editable).boolValue
        }
        
        if let _: AnyObject = infoDictionary[InfoDictionaryKeys.Editable] {
            if error != nil {
                let errorString = NSLocalizedString("Plugin editable is invalid \(infoDictionary).", comment: "Invalid plugin name error")
                error.memory = NSError.errorWithDescription(errorString, code: ClassConstants.errorCode)
            }
        }
        
        return true
    }

    class func validPluginTypeFromPath(path: String) -> PluginType {
        let pluginContainerDirectory = NSString(string: path).stringByDeletingLastPathComponent
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
