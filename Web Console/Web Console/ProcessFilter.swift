//
//  ProcessFilter.swift
//  Web Console
//
//  Created by Roben Kleene on 12/17/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation


class ProcessFilter {
    
    class func processesWithIdentifiers(identifiers: [String],
        completionHandler: ((processes: [ProcessInfo]?, error: NSError?) -> Void))
    {
        let commandPath = "/bin/ps"
        let arguments = ["-axww", "-o pid=,lstart=,args="]
        // a: All users
        // x: Not attached to terminal
        // ww: Don't truncate command
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
                completionHandler(processes: nil, error: error)
                return
            }

            guard let standardOutput = standardOutput else {
                completionHandler(processes: [ProcessInfo](), error: nil)
                return
            }
            
            let processInfos = processesFromOutput(standardOutput)
            completionHandler(processes: processInfos, error: nil)
        }
    }

    // MARK: Private

    class func processesFromOutput(output: String) -> [ProcessInfo] {

        var processInfos = [ProcessInfo]()
        let lines = output.componentsSeparatedByString("\n")
        for line in lines {
            if let processInfo = processFromLine(line) {
                processInfos.append(processInfo)
            }
        }
        
        return processInfos
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