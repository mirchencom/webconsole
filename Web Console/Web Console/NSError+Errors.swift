//
//  NSError+Errors.swift
//  Web Console
//
//  Created by Roben Kleene on 11/28/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

enum FileSystemError: ErrorType {
    case FileExistsForDirectoryError
}

enum TaskErrorCode: Int {
    case Unknown = 100, UnexecutableLaunchPath, Exception
}

extension NSError {
    
    // MARK: Generic
    
    class func errorWithDescription(description: String, code: Int) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: description]
        return NSError(domain: errorDomain, code: code, userInfo: userInfo)
    }

    // MARK: Running Plugins

    class func launchPathUnkownError(launchPath: String) -> NSError {
        return errorWithDescription("An unkown error occurred running command path: \(launchPath)", code: TaskErrorCode.Unknown.rawValue)
    }
    
    class func launchPathUnexecutableError(launchPath: String) -> NSError {
        return errorWithDescription("Command path is not executable: \(launchPath)", code: TaskErrorCode.UnexecutableLaunchPath.rawValue)
    }
    
    class func launchPathExceptionError(launchPath: String) -> NSError {
        return errorWithDescription("An exception was thrown running command path: \(launchPath)", code: TaskErrorCode.Exception.rawValue)
    }

}