//
//  ProcessFilter.swift
//  Web Console
//
//  Created by Roben Kleene on 12/17/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

extension ProcessFilter {
    class func runningProcessMatchingProcessInfos(_ processInfos: [ProcessInfo],
        completionHandler: @escaping ((_ identifierToProcessInfo: [Int32: ProcessInfo]?, _ error: NSError?) -> Void))
    {
        let identifiers = processInfos.map { $0.identifier }
        runningProcessesWithIdentifiers(identifiers) { (identifierToProcessInfo, error) -> Void in
            if let error = error {
                completionHandler(nil, error)
                return
            }

            guard var identifierToProcessInfo = identifierToProcessInfo else {
                completionHandler([Int32: ProcessInfo](), nil)
                return
            }
            
            for processInfo in processInfos {
                if let runningProcessInfo = identifierToProcessInfo[processInfo.identifier] {
                    if !doesRunningProcessInfo(runningProcessInfo, matchProcessInfo: processInfo) {
                        identifierToProcessInfo.removeValue(forKey: processInfo.identifier)
                    }
                }
            }

            completionHandler(identifierToProcessInfo, nil)
        }
    }

    class func doesRunningProcessInfo(_ runningProcessInfo: ProcessInfo,
        matchProcessInfo processInfo: ProcessInfo) -> Bool
    {
        assert(runningProcessInfo.identifier == processInfo.identifier)
        
        // Make sure the running process started on or before the other `ProcessInfo`'s `startTime`
        if runningProcessInfo.startTime.compare(processInfo.startTime as Date) == ComparisonResult.orderedDescending {
            return false
        }
        
        return true
    }
}

class ProcessFilter {
    
    class func runningProcessesWithIdentifiers(_ identifiers: [Int32],
        completionHandler: @escaping ((_ identifierToProcessInfo: [Int32: ProcessInfo]?, _ error: NSError?) -> Void))
    {
        if identifiers.isEmpty {
            let error = NSError.errorWithDescription("No identifiers specified")
            completionHandler(identifierToProcessInfo: nil, error: error)
            return
        }
        
        let commandPath = "/bin/ps"
        let identifiersParameter = identifiers.map({ String($0) }).joined(separator: ",")
        let arguments = ["-o pid=,lstart=,args=", "-p \(identifiersParameter)"]

        // o: Change format
        // pid: Process ID
        // lstart: Start time
        // args: Command & Arguments
        // = Means don't display header for this column
        
        WCLTaskRunner.runTaskUntilFinishedWithCommandPath(commandPath,
            withArguments: arguments,
            inDirectoryPath: nil)
        { (standardOutput, standardError, error) -> Void in

            if let error = error {

                if error.code == NSError.TaskTerminatedErrorCode.nonzeroExitStatus.rawValue {
                    if let exitStatus = error.userInfo[NSError.TaskTerminatedUserInfoKey.exitStatus.rawValue] as? NSNumber
                        , exitStatus.int32Value == 1
                    {
                        // If the process identifier is not found, `ps` exits with an exit status of 1
                        // So reinterpret that case as no processes found
                        completionHandler(identifierToProcessInfo: [Int32: ProcessInfo](), error: nil)
                        return
                    }
                }

                completionHandler(identifierToProcessInfo: nil, error: error)
                return
            }

            guard let standardOutput = standardOutput else {
                completionHandler(identifierToProcessInfo: [Int32: ProcessInfo](), error: nil)
                return
            }
            
            let processInfos = processesFromOutput(standardOutput)
            completionHandler(identifierToProcessInfo: processInfos, error: nil)
        }
    }

    // MARK: Private

    class func processesFromOutput(_ output: String) -> [Int32: ProcessInfo] {

        var identifierToProcessInfo = [Int32: ProcessInfo]()
        let lines = output.components(separatedBy: "\n")
        for line in lines {
            if let processInfo = processFromLine(line) {
                identifierToProcessInfo[processInfo.identifier] = processInfo
            }
        }
        
        return identifierToProcessInfo
    }
    
    fileprivate class func processFromLine(_ line: String) -> ProcessInfo? {
        if line.characters.count < 35 {
            return nil
        }
        
        let identifierStartIndex = line.characters.index(line.startIndex, offsetBy: 5)
        let rawIdentifier = line.substring(to: identifierStartIndex).trimmingCharacters(in: CharacterSet.whitespaces)
        
        let dateStartIndex = line.characters.index(line.startIndex, offsetBy: 6)
        let dateEndIndex = line.characters.index(line.startIndex, offsetBy: 30)
        let rawStartDate = line.substring(with: dateStartIndex..<dateEndIndex)
        
        let commandIndex = line.characters.index(line.startIndex, offsetBy: 35)
        let command = line.substring(from: commandIndex)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss yyyy"
        
        guard let identifier = Int32(rawIdentifier), let date = dateFormatter.date(from: rawStartDate) else {
            return nil
        }
        
        return ProcessInfo(identifier: identifier, startTime: date, commandPath: command)
    }
    
}
