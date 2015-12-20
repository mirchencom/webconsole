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

        WCLTaskRunner.runTaskUntilFinishedWithCommandPath(commandPath, withArguments: nil, inDirectoryPath: nil)
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
        
        return [ProcessInfo]()
    }

}