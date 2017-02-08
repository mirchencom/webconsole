//
//  NSError+Errors.swift
//  Web Console
//
//  Created by Roben Kleene on 11/28/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

let errorDomain = Bundle.main.bundleIdentifier!
let errorCode = 100

// MARK: Generic

extension NSError {

    class func error(description: String) -> NSError {
        return error(description: description, code: errorCode)
    }
    
    class func error(description: String, code: Int) -> NSError
    {
        return error(userInfo: [NSLocalizedDescriptionKey: description],
            code: code)
    }

    class func error(userInfo: [AnyHashable: Any],
        code: Int) -> NSError
    {
        return NSError(domain: errorDomain, code: code, userInfo: userInfo)
    }

}
