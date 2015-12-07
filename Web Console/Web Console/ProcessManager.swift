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
        case Arguments = "arguments"
        case DirectoryPath = "directoryPath"
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

    func removeProcessWithIdentifier(identifier: Int) -> ProcessInfo? {
        return processInfoForIdentifier(identifier, remove: true)
    }
    
    func processInfoWithIdentifier(identifier: Int) -> ProcessInfo? {
        return processInfoForIdentifier(identifier, remove: false)
    }

    // MARK: Private
    
    private func save() {
        processManagerStore.setObject(identifierKeyToProcessInfoValue, forKey: runningProcessesKey)
    }

    private func processInfoForIdentifier(identifier: Int, remove: Bool) -> ProcessInfo? {
        guard let processInfoValue = processInfoValueForIdentifier(identifier, remove: remove) else {
            return nil
        }

        return self.dynamicType.processInfoForValue(processInfoValue)
    }

    // MARK: Helper
    
    private func processInfoValueForIdentifier(identifier: Int, remove: Bool) -> NSDictionary? {
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
            let arguments = dictionary[ProcessInfoKey.Arguments.key()] as? [String],
            let directoryPath = dictionary[ProcessInfoKey.DirectoryPath.key()] as? String,
            let startTime = dictionary[ProcessInfoKey.StartTime.key()] as? NSDate
        else {
            return nil
        }

        let identifier = keyToIdentifier(key)
        
        return ProcessInfo(identifier: identifier,
            commandPath: commandPath,
            arguments: arguments,
            directoryPath: directoryPath,
            startTime: startTime)
    }
    
    private class func valueForProcessInfo(processInfo: ProcessInfo) -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary[ProcessInfoKey.Identifier.key()] = processInfo.identifier
        dictionary[ProcessInfoKey.CommandPath.key()] = processInfo.commandPath
        dictionary[ProcessInfoKey.Arguments.key()] = processInfo.arguments
        dictionary[ProcessInfoKey.DirectoryPath.key()] = processInfo.directoryPath
        dictionary[ProcessInfoKey.StartTime.key()] = processInfo.startTime
        return dictionary
    }
    
    private class func keyToIdentifier(key: NSNumber) -> Int {
        return Int(key.intValue)
    }
    
    private class func identifierToKey(value: Int) -> NSNumber {
        let valueInt32 = Int32(value)
        let valueNumber = NSNumber(int: valueInt32)
        return valueNumber
    }
}