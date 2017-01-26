//
//  SubprocessFileSystemModifier.swift
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 11/22/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

import Cocoa

class SubprocessFileSystemModifier {

    // MARK: createFileAtPath
    class func createFileAtPath(path: String) {
        createFileAtPath(path, handler: nil)
    }
    class func createFileAtPath(path: String, handler: ((Void) -> Void)?) {
        let task = Process()
        task.launchPath = "/usr/bin/touch"
        task.arguments = [path]
        SubprocessFileSystemModifier.runTask(task, handler: handler)
    }

    // MARK: createDirectoryAtPath
    class func createDirectoryAtPath(path: String) {
        createDirectoryAtPath(path, handler: nil)
    }
    class func createDirectoryAtPath(path: String, handler: ((Void) -> Void)?) {
        let task = Process()
        task.launchPath = "/bin/mkdir"
        task.arguments = [path]
        SubprocessFileSystemModifier.runTask(task, handler: handler)
    }

    // MARK: removeFileAtPath
    class func removeFileAtPath(path: String) {
        removeFileAtPath(path, handler: nil)
    }
    class func removeFileAtPath(path: String, handler: ((Void) -> Void)?) {
        let pathAsNSString: NSString = path as NSString
        if pathAsNSString.range(of: "*").location != NSNotFound {
            assert(false, "The path should not contain a wildcard")
            return
        }
        let task = Process()
        task.launchPath = "/bin/rm"
        task.arguments = [path]
        SubprocessFileSystemModifier.runTask(task, handler: handler)
    }
    
    // MARK: removeDirectoryAtPath
    class func removeDirectoryAtPath(path: String) {
        removeDirectoryAtPath(path, handler: nil)
    }
    class func removeDirectoryAtPath(path: String, handler: ((Void) -> Void)?) {
        let pathAsNSString: NSString = path as NSString
        if pathAsNSString.range(of: "*").location != NSNotFound {
            assert(false, "The path should not contain a wildcard")
            return
        }
        if !path.hasPrefix("/var/folders/") {
            assert(false, "The path should be a temporary directory")
            return
        }
        let task = Process()
        task.launchPath = "/bin/rm"
        task.arguments = ["-r", path]
        SubprocessFileSystemModifier.runTask(task, handler: handler)
    }

    // MARK: copyDirectoryAtPath
    class func copyDirectoryAtPath(path: String, toPath destinationPath: String) {
        copyDirectoryAtPath(path, toPath: destinationPath, handler: nil)
    }
    class func copyDirectoryAtPath(path: String, toPath destinationPath: String, handler: ((Void) -> Void)?) {
        let pathAsNSString: NSString = path as NSString
        if pathAsNSString.range(of: "*").location != NSNotFound {
            assert(false, "The path should not contain a wildcard")
            return
        }
        let destinationPathAsNSString: NSString = destinationPath as NSString
        if destinationPathAsNSString.range(of: "*").location != NSNotFound {
            assert(false, "The destination path should not contain a wildcard")
            return
        }
        if !path.hasPrefix("/var/folders/") {
            assert(false, "The path should be a temporary directory")
            return
        }
        if !destinationPath.hasPrefix("/var/folders/") {
            assert(false, "The destination path should be a temporary directory")
            return
        }
        if path.hasSuffix("/") {
            assert(false, "The path should not end with a slash")
            return
        }
        if destinationPath.hasSuffix("/") {
            assert(false, "The path should not end with a slash")
            return
        }
        
        let task = Process()
        task.launchPath = "/bin/cp"
        task.arguments = ["-R", path, destinationPath]
        SubprocessFileSystemModifier.runTask(task, handler: handler)
    }
    
    // MARK: moveItemAtPath
    class func moveItemAtPath(path: String, toPath destinationPath: String) {
        moveItemAtPath(path, toPath: destinationPath, handler: nil)
    }
    class func moveItemAtPath(path: String, toPath destinationPath: String, handler: ((Void) -> Void)?) {
        let task = Process()
        task.launchPath = "/bin/mv"
        task.arguments = [path, destinationPath]
        SubprocessFileSystemModifier.runTask(task, handler: handler)
    }

    // MARK: Helpers

    class func runTask(task: Process, handler: ((Void) -> Void)?) {
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
    }

    class func writeToFileAtPath(path: String, contents: String) {
        let echoTask = Process()
        echoTask.launchPath = "/bin/echo"
        echoTask.arguments = [contents]
        let pipe = Pipe()
        echoTask.standardOutput = pipe
        
        let teeTask = Process()
        teeTask.launchPath = "/usr/bin/tee"
        teeTask.arguments = [path]
        teeTask.standardInput = pipe
        teeTask.standardOutput = Pipe() // Suppress stdout
        
        teeTask.launch()
        echoTask.launch()
    }
}
