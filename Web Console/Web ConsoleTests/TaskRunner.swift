//
//  TaskRunner.swift
//  Web Console
//
//  Created by Roben Kleene on 12/16/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

class TaskRunner {

    class func runLaunchPath(launchPath: String, handler: ((Void) -> Void)?) -> Process {
        let task = Process()
        task.launchPath = launchPath
        return runTask(_ task, _ handler: handler)
    }
    
    class func runTask(task: Process, handler: ((Void) -> Void)?) -> Process {
        task.standardOutput = Pipe()
        (task.standardOutput! as AnyObject).fileHandleForReading.readabilityHandler = { (file: FileHandle!) -> Void in
            let data = file.availableData
            if let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                print("standardOutput \(output)")
            }
        }
        
        task.standardError = Pipe()
        (task.standardError! as AnyObject).fileHandleForReading.readabilityHandler = { (file: FileHandle!) -> Void in
            let data = file.availableData
            if let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                print("standardError \(output)")
                assert(false, "There should not be output to standard error")
            }
        }
        
        task.terminationHandler = { (task: Process) -> Void in
            handler?()
            (task.standardOutput! as AnyObject).fileHandleForReading.readabilityHandler = nil
            (task.standardError! as AnyObject).fileHandleForReading.readabilityHandler = nil
        }
        
        task.launch()
        return task
    }
}
