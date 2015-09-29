//
//  String+Paths.swift
//  Web Console
//
//  Created by Roben Kleene on 9/22/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

// TODO: Refactor this when Swift has native support for paths

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        return (self as NSString).stringByAppendingPathComponent(path)
    }

    func stringByAppendingPathExtension(ext: String) -> String? {
        return (self as NSString).stringByAppendingPathExtension(ext)
    }

    var stringByDeletingLastPathComponent: String {
        return (self as NSString).stringByDeletingLastPathComponent
    }

    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    var stringByStandardizingPath: String {
        return (self as NSString).stringByStandardizingPath
    }
    
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    var stringByDeletingPathExtension: String {
        return (self as NSString).stringByDeletingPathExtension
    }
}