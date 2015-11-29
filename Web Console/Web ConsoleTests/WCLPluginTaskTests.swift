//
//  WCLPluginTaskTests.swift
//  Web Console
//
//  Created by Roben Kleene on 11/28/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest

class WCLPluginTaskTests: XCTestCase, WCLPluginTaskDelegate {

    func testExample() {
        let expection = expectationWithDescription("Run task")
        WCLPluginTask.runTaskWithCommandPath("invalid path", withArguments: nil, inDirectoryPath: nil, delegate: self) { (success) -> Void in
            XCTAssertFalse(success)
            expection.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }

}
