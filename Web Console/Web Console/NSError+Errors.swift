//
//  NSError+Errors.swift
//  Web Console
//
//  Created by Roben Kleene on 11/28/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

let errorDomain = NSBundle.mainBundle().bundleIdentifier!

enum FileSystemError: ErrorType {
    case FileExistsForDirectoryError
}

enum RunCommandPathErrorCode: Int {
    case Unknown = 100, Unexecutable, Exception
}

extension NSError {
    
    // MARK: Generic
    
    class func errorWithDescription(description: String, code: Int) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: description]
        return NSError(domain: errorDomain, code: code, userInfo: userInfo)
    }

    // MARK: Running Plugins

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