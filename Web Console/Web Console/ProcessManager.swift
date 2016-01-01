//
//  ProcessManager.swift
//  Web Console
//
//  Created by Roben Kleene on 12/6/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

extension NSUserDefaults: ProcessManagerStore { }

protocol ProcessManagerStore {
    func setObject(value: AnyObject?, forKey defaultName: String)
    func dictionaryForKey(defaultName: String) -> [String : AnyObject]?
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
    
    let processManagerStore: ProcessManagerStore
    var identifierKeyToProcessInfoValue = [NSNumber: AnyObject]()

    convenience init() {
        self.init(processManagerStore: NSUserDefaults.standardUserDefaults())
    }
    
    init(processManagerStore: ProcessManagerStore) {
        self.processManagerStore = processManagerStore
    }
    
    func addProcessInfo(processInfo: ProcessInfo) {
        let keyValue = self.dynamicType.keyAndValueForProcessInfo(processInfo)
        identifierKeyToProcessInfoValue[keyValue.key] = keyValue.value
        save()
    }

    func removeProcessWithIdentifier(identifier: Int32) -> ProcessInfo? {
        return processInfoForIdentifier(identifier, remove: true)
    }
    
    func processInfoWithIdentifier(identifier: Int32) -> ProcessInfo? {
        return processInfoForIdentifier(identifier, remove: false)
    }

    func processInfos() -> [ProcessInfo] {
        let values = identifierKeyToProcessInfoValue.values
        var processInfos = [ProcessInfo]()

        for value in values {
            if let
                value = value as? NSDictionary,
                processInfo = self.dynamicType.processInfoForValue(value)
            {
                processInfos.append(processInfo)
            }
        }

        return processInfos
    }
    
    // MARK: Private
    
    private func save() {
        processManagerStore.setObject(identifierKeyToProcessInfoValue, forKey: runningProcessesKey)
    }

    private func processInfoForIdentifier(identifier: Int32, remove: Bool) -> ProcessInfo? {
        guard let processInfoValue = processInfoValueForIdentifier(identifier, remove: remove) else {
            return nil
        }

        return self.dynamicType.processInfoForValue(processInfoValue)
    }

    // MARK: Helper
    
    private func processInfoValueForIdentifier(identifier: Int32, remove: Bool) -> NSDictionary? {
        let key = self.dynamicType.identifierToKey(identifier)
        if remove {
            let processInfoValue = identifierKeyToProcessInfoValue.removeValueForKey(key) as? NSDictionary
            save()
            return processInfoValue
        } else {
            return identifierKeyToProcessInfoValue[key] as? NSDictionary
        }
    }
    
    private class func keyAndValueForProcessInfo(processInfo: ProcessInfo) -> (key: NSNumber, value: NSDictionary) {
        let key = identifierToKey(processInfo.identifier)
        let value = valueForProcessInfo(processInfo)
        return (key: key, value: value)
    }
    
    private class func processInfoForValue(dictionary: NSDictionary) -> ProcessInfo? {
        guard
            let key = dictionary[ProcessInfoKey.Identifier.key()] as? NSNumber,
            let commandPath = dictionary[ProcessInfoKey.CommandPath.key()] as? String,
            let startTime = dictionary[ProcessInfoKey.StartTime.key()] as? NSDate
        else {
            return nil
        }

        let identifier = keyToIdentifier(key)
        
        return ProcessInfo(identifier: identifier,
            startTime: startTime,
            commandPath: commandPath)
    }
    
    private class func valueForProcessInfo(processInfo: ProcessInfo) -> NSDictionary {
        let dictionary = NSMutableDictionary()
        let key = identifierToKey(processInfo.identifier)
        dictionary[ProcessInfoKey.Identifier.key()] = key
        dictionary[ProcessInfoKey.CommandPath.key()] = processInfo.commandPath
        dictionary[ProcessInfoKey.StartTime.key()] = processInfo.startTime
        return dictionary
    }
    
    private class func keyToIdentifier(key: NSNumber) -> Int32 {
        return Int32(key.intValue)
    }
    
    private class func identifierToKey(value: Int32) -> NSNumber {
        let valueNumber = NSNumber(int: value)
        return valueNumber
    }
}