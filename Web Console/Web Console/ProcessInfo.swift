//
//  ProcessInfo.swift
//  Web Console
//
//  Created by Roben Kleene on 12/6/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

struct ProcessInfo {
    let identifier: Int
    let commandPath: String
    let arguments: [String]
    let directoryPath: String
    let startTime: NSDate
}