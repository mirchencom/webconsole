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
    init?(identifier: Int32, startTime: NSDate, commandPath: String) {
        // An all whitespace `commandPath` is not allowed
        let trimmedCommandPathCharacterCount = commandPath
            .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            .characters
            .count
        if !(trimmedCommandPathCharacterCount > 0) {
            return nil
        }
        
        self.identifier = identifier
        self.startTime = startTime
        self.commandPath = commandPath
    }
}

func ==(lhs: ProcessInfo, rhs: ProcessInfo) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.commandPath == rhs.commandPath &&
        lhs.startTime == rhs.startTime
}