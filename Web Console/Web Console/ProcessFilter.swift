//
//  ProcessFilter.swift
//  Web Console
//
//  Created by Roben Kleene on 12/17/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

struct TaskResult {
    let standardOutput: String?
    let standardError: String?
    let error: NSError
}

extension TaskResultsCollector: WCLTaskRunnerDelegate {
    
    func taskDidFinish(task: NSTask) {
        
    }

    func task(task: NSTask, didReadFromStandardError text: String) {
        appendToStandardError(text)
    }

    func task(task: NSTask, didReadFromStandardOutput text: String) {
        appendToStandardOutput(text)
    }
}

class TaskResultsCollector: NSObject {
    var standardOutput: String?
    var standardError: String?

    let completionHandler: (result: TaskResult) -> Void
    init(completionHandler: (result: TaskResult) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func appendToStandardOutput(text: String) {
        if standardOutput == nil {
            standardOutput = String()
        }
    }

    func appendToStandardError(text: String) {
        if standardError == nil {
            standardError = String()
        }
    }

}

class ProcessFilter {

    class func processesWithIdentifiers(identifiers: [String],
        completionHandler: ((processes: [ProcessInfo]?, error: NSError?) -> Void))
    {
        let commandPath = "/bin/ps"
        let taskResultsCollector = TaskResultsCollector { taskResult in

            // Have to cancel and fire this if there's a timeout
            
            let processesResult = processesFromResult(taskResult)
            completionHandler(processes: processesResult.processes, error: processesResult.error)
        }

        WCLTaskRunner.runTaskWithCommandPath(commandPath, withArguments: nil, inDirectoryPath: nil, delegate: taskResultsCollector, completionHandler: nil)
        
        // TODO: Give this a timeout, create an error for the timeout
        
    }


    class func processesFromResult(taskResult: TaskResult) -> (processes: [ProcessInfo]?, error: NSError?) {
        // TODO: Implement
        return (processes: nil, error: nil)
    }

}