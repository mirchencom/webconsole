//
//  NSError+Errors.swift
//  Web Console
//
//  Created by Roben Kleene on 11/28/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

let errorDomain = NSBundle.mainBundle().bundleIdentifier!
let errorCode = 100

// MARK: Generic

extension NSError {

    class func errorWithDescription(description: String) -> NSError {
        return errorWithDescription(description,
            code: errorCode)
    }
    
    class func errorWithDescription(description: String,
        code: Int) -> NSError
    {
        return errorWithUserInfo([NSLocalizedDescriptionKey: description],
            code: code)
    }

    class func errorWithUserInfo(userInfo: [NSObject : AnyObject],
        code: Int) -> NSError
    {
        return NSError(domain: errorDomain, code: code, userInfo: userInfo)
    }

}