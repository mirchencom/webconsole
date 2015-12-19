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
    let error: NSError?
}

extension NSError {
    
    class func taskTerminatedUncaughtSignalError(launchPath: String?, standardError: String?) -> NSError {
        var description = "An uncaught signal error occurred"
        if let launchPath = launchPath {
            description += " running launch path: \(launchPath)"
        }

        if let standardError = standardError {
            description += ", standardError: \(standardError)"
        }
        
        return errorWithDescription(description)
    }

    class func taskTerminatedNonzeroExitCode(launchPath: String?, exitCode: Int32, standardError: String?) -> NSError {
        var description = "Terminated with a nonzero exit status \(exitCode)"
        if let launchPath = launchPath {
            description += " running launch path: \(launchPath)"
        }
        
        if let standardError = standardError {
            description += ", standardError: \(standardError)"
        }
        
        return errorWithDescription(description)
    }

    
}

extension TaskResultsCollector: WCLTaskRunnerDelegate {
    
    func taskDidFinish(task: NSTask) {
        assert(!task.running)
        let error = errorForTask(task)
        let taskResult = TaskResult(standardOutput: standardOutput, standardError: standardError, error: error)
        completionHandler(result: taskResult)
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
    var error: NSError?
    
    let completionHandler: (result: TaskResult) -> Void
    init(completionHandler: (result: TaskResult) -> Void) {
        self.completionHandler = completionHandler
    }
    
    private func appendToStandardOutput(text: String) {
        if standardOutput == nil {
            standardOutput = String()
        }
    }

    private func appendToStandardError(text: String) {
        if standardError == nil {
            standardError = String()
        }
    }

    private func errorForTask(task: NSTask) -> NSError? {
        assert(!task.running)
        if task.terminationStatus == 0 && task.terminationReason == .Exit {
            return nil
        }

        if task.terminationReason == .UncaughtSignal {
            return NSError.taskTerminatedUncaughtSignalError(task.launchPath, standardError: standardError)
        }

        return NSError.taskTerminatedNonzeroExitCode(task.launchPath, exitCode: task.terminationStatus, standardError: standardError)
    }
    
}

extension WCLTaskRunner {

    class func runTaskWithCommandPath(commandPath: String,
        withArguments arguments: [AnyObject]?,
        inDirectoryPath directoryPath: String?,
        timeout: NSTimeInterval,
        delegate: WCLTaskRunnerDelegate?,
        completionHandler: ((Bool) -> Void)?) -> NSTask
    {
        let task = runTaskWithCommandPath(commandPath,
            withArguments: arguments,
            inDirectoryPath: directoryPath,
            delegate: delegate,
            completionHandler: completionHandler)

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            if task.running {
                task.wcl_interruptWithCompletionHandler({ (success) -> Void in
                    assert(success)
                })
            }
        }

        return task
    }
}

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
        let taskResultsCollector = TaskResultsCollector { taskResult in
            if let error = taskResult.error {
                completionHandler(processes: nil, error: error)
                return
            }
            
            let processesResult = processesFromResult(taskResult)
            completionHandler(processes: processesResult.processes, error: processesResult.error)
        }
        
        WCLTaskRunner.runTaskWithCommandPath(commandPath,
            withArguments: nil,
            inDirectoryPath: nil,
            timeout: timeout,
            delegate: taskResultsCollector,
            completionHandler: nil)
    }

    // MARK: Private

    private class func processesFromResult(taskResult: TaskResult) -> (processes: [ProcessInfo]?, error: NSError?) {
        
        // TODO: Implement

        // TODO: Return empty array if output is empty
        
        return (processes: nil, error: nil)
    }

}