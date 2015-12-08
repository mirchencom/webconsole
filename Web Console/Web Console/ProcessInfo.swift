//
//  ProcessInfo.swift
//  Web Console
//
//  Created by Roben Kleene on 12/6/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

struct ProcessInfo: Equatable {
    let identifier: Int
    let commandPath: String
    let arguments: [String]
    let directoryPath: String
    let startTime: NSDate
}

func ==(lhs: ProcessInfo, rhs: ProcessInfo) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.commandPath == rhs.commandPath &&
        lhs.arguments == rhs.arguments &&
        lhs.directoryPath == rhs.directoryPath &&
        lhs.startTime == rhs.startTime
}