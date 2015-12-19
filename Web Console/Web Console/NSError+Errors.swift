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
    
    // MARK: Generic
    
    class func errorWithDescription(description: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: description]
        return NSError(domain: errorDomain, code: errorCode, userInfo: userInfo)
    }
    
    class func errorWithDescription(description: String, code: Int) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: description]
        return NSError(domain: errorDomain, code: code, userInfo: userInfo)
    }

}