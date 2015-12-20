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
        let timeout = 20.0
        processesWithIdentifiers(identifiers,
            timeout: timeout,
            completionHandler: completionHandler)
    }

    class func processesWithIdentifiers(identifiers: [String],
        timeout: NSTimeInterval,
        completionHandler: ((processes: [ProcessInfo]?, error: NSError?) -> Void))
    {
        let commandPath = "/bin/ps"
        let taskResultsCollector = TaskResultsCollector { standardOutput, _, error in

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
        
        WCLTaskRunner.runTaskWithCommandPath(commandPath,
            withArguments: nil,
            inDirectoryPath: nil,
            timeout: timeout,
            delegate: taskResultsCollector,
            completionHandler: nil)
    }

    // MARK: Private

    private class func processesFromOutput(output: String) -> [ProcessInfo] {
        
        // TODO: Implement

        // TODO: Return empty array if output is empty
        
        return [ProcessInfo]()
    }

}