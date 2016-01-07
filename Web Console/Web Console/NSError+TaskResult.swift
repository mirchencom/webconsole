//
//  NSError+TaskResult.swift
//  Web Console
//
//  Created by Roben Kleene on 1/6/16.
//  Copyright © 2016 Roben Kleene. All rights reserved.
//

import Foundation

extension NSError {
    
    enum TaskTerminatedUserInfoKey: NSString {
        case ExitStatus = "ExitStatus"
    }
    
    enum TaskTerminatedErrorCode: Int {
        case UncaughtSignal = 100, NonzeroExitStatus
    }
    
    class func taskTerminatedUncaughtSignalError(launchPath: String?,
        arguments: [String]?,
        directoryPath: String?,
        standardError: String?) -> NSError
    {
        var description = "An uncaught signal error occurred"
        if let launchPath = launchPath {
            description += " running launch path: \(launchPath)"
        }
        
        if let arguments = arguments {
            description += ", with arguments: \(arguments)"
        }
        
        if let directoryPath = directoryPath {
            description += ", in directory path: \(directoryPath)"
        }
        
        if let standardError = standardError {
            description += ", standardError: \(standardError)"
        }
        
        return errorWithDescription(description, code: TaskTerminatedErrorCode.UncaughtSignal.rawValue)
    }
    
    class func taskTerminatedNonzeroExitCode(launchPath: String?,
        exitCode: Int32,
        arguments: [String]?,
        directoryPath: String?,
        standardError: String?) -> NSError
    {
        var description = "Terminated with a nonzero exit status \(exitCode)"
        if let launchPath = launchPath {
            description += " running launch path: \(launchPath)"
        }
        
        if let arguments = arguments {
            description += ", with arguments: \(arguments)"
        }
        
        if let directoryPath = directoryPath {
            description += ", in directory path: \(directoryPath)"
        }
        
        if let standardError = standardError {
            description += ", standardError: \(standardError)"
        }
        
        let userInfo: [NSObject : AnyObject] = [NSLocalizedDescriptionKey: description,
            TaskTerminatedUserInfoKey.ExitStatus.rawValue: NSNumber(int: exitCode)]
        
        return errorWithUserInfo(userInfo, code: TaskTerminatedErrorCode.NonzeroExitStatus.rawValue)
    }
    
    
}
