//
//  WCLTastRunner+TaskResult.swift
//  Web Console
//
//  Created by Roben Kleene on 12/20/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation


extension TaskResultsCollector: WCLTaskRunnerDelegate {
    
    func taskDidFinish(task: NSTask) {
        assert(!task.running)
        let error = errorForTask(task)
        completionHandler(standardOutput: standardOutput, standardError: standardError, error: error)
    }

    func task(task: NSTask, didFailToRunCommandPath commandPath: String, error: NSError) {
        assert(!task.running)
        completionHandler(standardOutput: standardOutput, standardError: standardError, error: error)
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
    
    let completionHandler: WCLTaskRunner.TaskResult
    init(completionHandler: WCLTaskRunner.TaskResult) {
        self.completionHandler = completionHandler
    }
    
    private func appendToStandardOutput(text: String) {
        if standardOutput == nil {
            standardOutput = String()
        }

        standardOutput? += text
    }
    
    private func appendToStandardError(text: String) {
        if standardError == nil {
            standardError = String()
        }
        
        standardError? += text
    }
    
    private func errorForTask(task: NSTask) -> NSError? {
        assert(!task.running)
        if task.terminationStatus == 0 && task.terminationReason == .Exit {
            return nil
        }
        
        if task.terminationReason == .UncaughtSignal {
            return NSError.taskTerminatedUncaughtSignalError(task.launchPath,
                arguments: task.arguments,
                directoryPath: task.currentDirectoryPath,
                standardError: standardError)
        }
        
        return NSError.taskTerminatedNonzeroExitCode(task.launchPath, exitCode:
            task.terminationStatus,
            arguments: task.arguments,
            directoryPath: task.currentDirectoryPath,
            standardError: standardError)
    }
    
}

extension WCLTaskRunner {
    
    typealias TaskResult = (standardOutput: String?, standardError: String?, error: NSError?) -> Void
    

    class func runTaskUntilFinishedWithCommandPath(commandPath: String,
        withArguments arguments: [AnyObject]?,
        inDirectoryPath directoryPath: String?,
        completionHandler: WCLTaskRunner.TaskResult) -> NSTask
    {
        let timeout = 20.0
        return runTaskUntilFinishedWithCommandPath(commandPath,
            withArguments: arguments,
            inDirectoryPath: directoryPath,
            timeout: timeout,
            completionHandler: completionHandler)
    }

    class func runTaskUntilFinishedWithCommandPath(commandPath: String,
        withArguments arguments: [AnyObject]?,
        inDirectoryPath directoryPath: String?,
        timeout: NSTimeInterval,
        completionHandler: WCLTaskRunner.TaskResult) -> NSTask
    {
        let taskResultsCollector = TaskResultsCollector { standardOutput, standardError, error in
            completionHandler(standardOutput: standardOutput, standardError: standardError, error: error)
        }
        
        return runTaskWithCommandPath(commandPath,
            withArguments: arguments,
            inDirectoryPath: directoryPath,
            timeout: timeout,
            delegate: taskResultsCollector,
            completionHandler: nil)
    }
    
    
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
