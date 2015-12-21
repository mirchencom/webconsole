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

    private class func processesFromOutput(output: String) -> [ProcessInfo] {
        
        // TODO: Implement

        // TODO: Return empty array if output is empty

        print("output = \(output)")

//        let filePath = NSTemporaryDirectory().stringByAppendingPathComponent("web_console_output.txt")
//        NSLog("filePath = \(filePath)")
//        do {
//            try output.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
//        } catch {
//            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//        }
        
        
        return [ProcessInfo]()
    }

}