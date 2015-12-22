//
//  ProcessInfo.swift
//  Web Console
//
//  Created by Roben Kleene on 12/6/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import Foundation

struct ProcessInfo: Equatable {
    let identifier: Int32
    let startTime: NSDate
    let commandPath: String
}

func ==(lhs: ProcessInfo, rhs: ProcessInfo) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.commandPath == rhs.commandPath &&
        lhs.startTime == rhs.startTime
}