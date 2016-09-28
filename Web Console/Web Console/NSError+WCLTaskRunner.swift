//
//  NSError+WCLTaskRunner.swift
//  Web Console
//
//  Created by Roben Kleene on 12/19/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

enum FileSystemError: Error {
    case fileExistsForDirectoryError
}

enum RunCommandPathErrorCode: Int {
    case unknown = 100, unexecutable, exception
}

// MARK: WCLTaskRunner

extension NSError {
    
    class func commandPathUnkownError(_ launchPath: String) -> NSError {
        return errorWithDescription("An unkown error occurred running command path: \(launchPath)", code: RunCommandPathErrorCode.unknown.rawValue)
    }
    
    class func commandPathUnexecutableError(_ launchPath: String) -> NSError {
        return errorWithDescription("Command path is not executable: \(launchPath)", code: RunCommandPathErrorCode.unexecutable.rawValue)
    }
    
    class func commandPathExceptionError(_ launchPath: String) -> NSError {
        return errorWithDescription("An exception was thrown running command path: \(launchPath)", code: RunCommandPathErrorCode.exception.rawValue)
    }
    
}
