//
//  NSError+WCLTaskRunner.swift
//  Web Console
//
//  Created by Roben Kleene on 12/19/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

enum FileSystemError: ErrorType {
    case FileExistsForDirectoryError
}

enum RunCommandPathErrorCode: Int {
    case Unknown = 100, Unexecutable, Exception
}

// MARK: WCLTaskRunner

extension NSError {
    
    class func commandPathUnkownError(launchPath: String) -> NSError {
        return errorWithDescription("An unkown error occurred running command path: \(launchPath)", code: RunCommandPathErrorCode.Unknown.rawValue)
    }
    
    class func commandPathUnexecutableError(launchPath: String) -> NSError {
        return errorWithDescription("Command path is not executable: \(launchPath)", code: RunCommandPathErrorCode.Unexecutable.rawValue)
    }
    
    class func commandPathExceptionError(launchPath: String) -> NSError {
        return errorWithDescription("An exception was thrown running command path: \(launchPath)", code: RunCommandPathErrorCode.Exception.rawValue)
    }
    
}