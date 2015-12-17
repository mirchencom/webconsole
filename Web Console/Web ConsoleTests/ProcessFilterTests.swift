//
//  ProcessFilterTests.swift
//  Web Console
//
//  Created by Roben Kleene on 12/9/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest

@testable import Web_Console

class ProcessFilterTests: XCTestCase {
    
    func testProcessFilter() {

        let commandPath = pathForResource(testDataSleepTwoSeconds,
            ofType: testDataRubyFileExtension,
            inDirectory: testDataSubdirectory)!
        
        let expectation = expectationWithDescription("Task ran")
        TaskRunner.runLaunchPath(commandPath) {
            NSLog("Done")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(5.0, handler: nil)
    }

}
