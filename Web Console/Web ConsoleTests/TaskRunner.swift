//
//  TaskRunner.swift
//  Web Console
//
//  Created by Roben Kleene on 12/16/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

class TaskRunner {

    class func runLaunchPath(launchPath: String, handler: (Void -> Void)?) -> NSTask {
        let task = NSTask()
        task.launchPath = launchPath
        return runTask(task, handler: handler)
    }
    
    class func runTask(task: NSTask, handler: (Void -> Void)?) -> NSTask {
        task.standardOutput = NSPipe()
        task.standardOutput!.fileHandleForReading.readabilityHandler = { (file: NSFileHandle!) -> Void in
            let data = file.availableData
            if let output = NSString(data: data, encoding: NSUTF8StringEncoding) {
                print("standardOutput \(output)")
            }
        }
        
        task.standardError = NSPipe()
        task.standardError!.fileHandleForReading.readabilityHandler = { (file: NSFileHandle!) -> Void in
            let data = file.availableData
            if let output = NSString(data: data, encoding: NSUTF8StringEncoding) {
                print("standardError \(output)")
                assert(false, "There should not be output to standard error")
            }
        }
        
        task.terminationHandler = { (task: NSTask!) -> Void in
            handler?()
            task.standardOutput!.fileHandleForReading.readabilityHandler = nil
            task.standardError!.fileHandleForReading.readabilityHandler = nil
        }
        
        task.launch()
        return task
    }
}
