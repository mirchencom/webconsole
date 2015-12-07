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
    var identifierToProcess = [NSNumber: AnyObject]()

    convenience init() {
        self.init(processManagerStore: NSUserDefaults.standardUserDefaults())
    }
    
    init(processManagerStore: ProcessManagerStore) {
        self.processManagerStore = processManagerStore
    }
    
    func addProcessInfo(processInfo: ProcessInfo) {
        let keyValue = self.dynamicType.keyAndValueForProcessInfo(processInfo)
        identifierToProcess[keyValue.key] = keyValue.value
        save()
    }

    func removeProcessWithIdentifier(identifier: Int) -> ProcessInfo? {
        let key = self.dynamicType.identifierToKey(identifier)
        guard let processInfo = identifierToProcess[key] as? ProcessInfo else {
            return nil
        }

        identifierToProcess.removeValueForKey(key)
        save()
        return processInfo
    }
    
    func processInfoWithIdentifier(identifier: Int) -> ProcessInfo? {
        let key = self.dynamicType.identifierToKey(identifier)
        return identifierToProcess[key] as? ProcessInfo
    }

    // MARK: Private
    
    private func save() {
        processManagerStore.setObject(identifierToProcess, forKey: runningProcessesKey)
    }

    private class func keyAndValueForProcessInfo(processInfo: ProcessInfo) -> (key: NSNumber, value: NSDictionary) {
        let key = identifierToKey(processInfo.identifier)
        let value = valueForProcessInfo(processInfo)
        return (key: key, value: value)
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
    
    private class func identifierToKey(value: Int) -> NSNumber {
        let valueInt32 = Int32(value)
        let valueNumber = NSNumber(int: valueInt32)
        return valueNumber
    }
}