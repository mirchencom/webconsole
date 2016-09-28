//
//  ProcessManager.swift
//  Web Console
//
//  Created by Roben Kleene on 12/6/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

extension UserDefaults: ProcessManagerStore { }

protocol ProcessManagerStore {
    func setObject(_ value: AnyObject?, forKey defaultName: String)
    func dictionaryForKey(_ defaultName: String) -> [String : AnyObject]?
}
class ProcessManager {
    
    enum ProcessInfoKey: String {
        case Identifier = "identifier"
        case CommandPath = "commandPath"
        case StartTime = "startTime"
        func key() -> NSString {
            return self.rawValue as NSString
        }
    }
    
    fileprivate let processManagerStore: ProcessManagerStore
    fileprivate var identifierKeyToProcessInfoValue = [NSString: AnyObject]()
    
    convenience init() {
        self.init(processManagerStore: UserDefaultsManager.standardUserDefaults())
    }
    
    init(processManagerStore: ProcessManagerStore) {
        if let processInfoDictionary = processManagerStore.dictionaryForKey(runningProcessesKey) {
            identifierKeyToProcessInfoValue = processInfoDictionary as [NSString : AnyObject]
        }
        self.processManagerStore = processManagerStore
    }
    
    func addProcessInfo(_ processInfo: ProcessInfo) {
        let keyValue = type(of: self).keyAndValueForProcessInfo(processInfo)
        objc_sync_enter(self)
        identifierKeyToProcessInfoValue[keyValue.key] = keyValue.value
        objc_sync_exit(self)
        save()
    }
    
    func removeProcessWithIdentifier(_ identifier: Int32) -> ProcessInfo? {
        let processInfo = processInfoForIdentifier(identifier, remove: true)
        return processInfo
    }
    
    func processInfoWithIdentifier(_ identifier: Int32) -> ProcessInfo? {
        return processInfoForIdentifier(identifier, remove: false)
    }
    
    func processInfos() -> [ProcessInfo] {
        objc_sync_enter(self)
        let values = identifierKeyToProcessInfoValue.values
        objc_sync_exit(self)
        
        var processInfos = [ProcessInfo]()
        
        for value in values {
            if let
                value = value as? NSDictionary,
                let processInfo = type(of: self).processInfoForValue(value)
            {
                processInfos.append(processInfo)
            }
        }
        
        return processInfos
    }
    
    // MARK: Private
    
    fileprivate func save() {
        processManagerStore.setObject(identifierKeyToProcessInfoValue as AnyObject?, forKey: runningProcessesKey)
    }
    
    fileprivate func processInfoForIdentifier(_ identifier: Int32, remove: Bool) -> ProcessInfo? {
        guard let processInfoValue = processInfoValueForIdentifier(identifier, remove: remove) else {
            return nil
        }
        
        return type(of: self).processInfoForValue(processInfoValue)
    }
    
    // MARK: Helper
    
    fileprivate func processInfoValueForIdentifier(_ identifier: Int32, remove: Bool) -> NSDictionary? {
        let key = type(of: self).identifierToKey(identifier)
        if remove {
            objc_sync_enter(self)
            let processInfoValue = identifierKeyToProcessInfoValue.removeValue(forKey: key) as? NSDictionary
            objc_sync_exit(self)
            save()
            return processInfoValue
        } else {
            objc_sync_enter(self)
            let value = identifierKeyToProcessInfoValue[key] as? NSDictionary
            objc_sync_exit(self)
            return value
        }
    }
    
    fileprivate class func keyAndValueForProcessInfo(_ processInfo: ProcessInfo) -> (key: NSString, value: NSDictionary) {
        let key = identifierToKey(processInfo.identifier)
        let value = valueForProcessInfo(processInfo)
        return (key: key, value: value)
    }
    
    fileprivate class func processInfoForValue(_ dictionary: NSDictionary) -> ProcessInfo? {
        guard
            let key = dictionary[ProcessInfoKey.Identifier.key()] as? NSString,
            let commandPath = dictionary[ProcessInfoKey.CommandPath.key()] as? String,
            let startTime = dictionary[ProcessInfoKey.StartTime.key()] as? Date
        else {
            return nil
        }
        
        let identifier = keyToIdentifier(key)
        
        return ProcessInfo(identifier: identifier,
            startTime: startTime,
            commandPath: commandPath)
    }
    
    fileprivate class func valueForProcessInfo(_ processInfo: ProcessInfo) -> NSDictionary {
        let dictionary = NSMutableDictionary()
        let key = identifierToKey(processInfo.identifier)
        dictionary[ProcessInfoKey.Identifier.key()] = key
        dictionary[ProcessInfoKey.CommandPath.key()] = processInfo.commandPath
        dictionary[ProcessInfoKey.StartTime.key()] = processInfo.startTime
        return dictionary
    }
    
    fileprivate class func keyToIdentifier(_ key: NSString) -> Int32 {
        return Int32(key.intValue)
    }
    
    fileprivate class func identifierToKey(_ value: Int32) -> NSString {
        let valueNumber = String(value)
        return valueNumber as NSString
    }
}
