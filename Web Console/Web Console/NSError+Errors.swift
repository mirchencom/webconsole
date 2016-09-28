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

    class func errorWithDescription(_ description: String) -> NSError {
        return errorWithDescription(description,
            code: errorCode)
    }
    
    class func errorWithDescription(_ description: String,
        code: Int) -> NSError
    {
        return errorWithUserInfo([NSLocalizedDescriptionKey: description],
            code: code)
    }

    class func errorWithUserInfo(_ userInfo: [AnyHashable: Any],
        code: Int) -> NSError
    {
        return NSError(domain: errorDomain, code: code, userInfo: userInfo)
    }

}
