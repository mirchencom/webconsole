//
//  WCLPluginTaskTests.swift
//  Web Console
//
//  Created by Roben Kleene on 11/28/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest

extension WCLPluginTaskTests: WCLPluginTaskDelegate {
    func pluginTask(task: NSTask, didFailToRunCommandPath commandPath: String, error: NSError) {
        XCTAssertNotNil(error)
        XCTAssert(error.code == RunCommandPathErrorCode.Unexecutable.rawValue)
        if let didFailToRunCommandPathExpectation = didFailToRunCommandPathExpectation {
            didFailToRunCommandPathExpectation.fulfill()
        }
    }
}

class WCLPluginTaskTests: XCTestCase {

    var didFailToRunCommandPathExpectation: XCTestExpectation?
    
    func testExample() {
        let expection = expectationWithDescription("Run task")
        didFailToRunCommandPathExpectation = expectationWithDescription("Did fail to run command path")
        
        WCLPluginTask.runTaskWithCommandPath("invalid path", withArguments: nil, inDirectoryPath: nil, delegate: self) { (success) -> Void in
            XCTAssertFalse(success)
            expection.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }

}
