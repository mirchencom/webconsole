//
//  ProcessFilter.swift
//  Web Console
//
//  Created by Roben Kleene on 12/17/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

extension ProcessFilter {
    class func runningProcessMatchingProcessInfos(processInfos: [ProcessInfo],
        completionHandler: ((identifierToProcessInfo: [Int32: ProcessInfo]?, error: NSError?) -> Void))
    {
        let identifiers = processInfos.map { $0.identifier }
        runningProcessesWithIdentifiers(identifiers) { (identifierToProcessInfo, error) -> Void in
            if let error = error {
                completionHandler(identifierToProcessInfo: nil, error: error)
                return
            }

            guard var identifierToProcessInfo = identifierToProcessInfo else {
                completionHandler(identifierToProcessInfo: [Int32: ProcessInfo](), error: nil)
                return
            }
            
            for processInfo in processInfos {
                if let runningProcessInfo = identifierToProcessInfo[processInfo.identifier] {
                    if !doesRunningProcessInfo(runningProcessInfo, matchProcessInfo: processInfo) {
                        identifierToProcessInfo.removeValueForKey(processInfo.identifier)
                    }
                }
            }

            completionHandler(identifierToProcessInfo: identifierToProcessInfo, error: nil)
        }
    }

    class func doesRunningProcessInfo(runningProcessInfo: ProcessInfo,
        matchProcessInfo processInfo: ProcessInfo) -> Bool
    {
        assert(runningProcessInfo.identifier == processInfo.identifier)
        
        // Make sure the running process started on or before the other `ProcessInfo`'s `startTime`
        if runningProcessInfo.startTime.compare(processInfo.startTime) == NSComparisonResult.OrderedDescending {
            return false
        }
        
        return true
    }
}

class ProcessFilter {
    
    class func runningProcessesWithIdentifiers(identifiers: [Int32],
        completionHandler: ((identifierToProcessInfo: [Int32: ProcessInfo]?, error: NSError?) -> Void))
    {
        if identifiers.isEmpty {
            let error = NSError.errorWithDescription("No identifiers specified")
            completionHandler(identifierToProcessInfo: nil, error: error)
            return
        }
        
        let commandPath = "/bin/ps"
        let identifiersParameter = identifiers.map({ String($0) }).joinWithSeparator(",")
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

    class func processesFromOutput(output: String) -> [Int32: ProcessInfo] {

        var identifierToProcessInfo = [Int32: ProcessInfo]()
        let lines = output.componentsSeparatedByString("\n")
        for line in lines {
            if let processInfo = processFromLine(line) {
                identifierToProcessInfo[processInfo.identifier] = processInfo
            }
        }
        
        return identifierToProcessInfo
    }
    
    private class func processFromLine(line: String) -> ProcessInfo? {
        if line.characters.count < 35 {
            return nil
        }
        
        let identifierStartIndex = line.startIndex.advancedBy(5)
        let rawIdentifier = line.substringToIndex(identifierStartIndex).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let dateStartIndex = line.startIndex.advancedBy(6)
        let dateEndIndex = line.startIndex.advancedBy(30)
        let rawStartDate = line.substringWithRange(Range(start: dateStartIndex, end: dateEndIndex))
        
        let commandIndex = line.startIndex.advancedBy(35)
        let command = line.substringFromIndex(commandIndex)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss yyyy"
        
        guard let identifier = Int32(rawIdentifier), date = dateFormatter.dateFromString(rawStartDate) else {
            return nil
        }
        
        return ProcessInfo(identifier: identifier, startTime: date, commandPath: command)
    }
    
}