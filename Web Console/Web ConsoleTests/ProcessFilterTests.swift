//
//  ProcessFilterTests.swift
//  Web Console
//
//  Created by Roben Kleene on 12/9/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest

@testable import Web_Console

// TODO: Test if no valid process is found, than an empty array is returned

class ProcessFilterTests: XCTestCase {
    
//    func testWithProcess() {
//
//        let commandPath = pathForResource(testDataSleepTwoSeconds,
//            ofType: testDataRubyFileExtension,
//            inDirectory: testDataSubdirectory)!
//        
//        let expectation = expectationWithDescription("Task ran")
//        TaskRunner.runLaunchPath(commandPath) {
//            NSLog("Done")
//            expectation.fulfill()
//        }
//
//        waitForExpectationsWithTimeout(5.0, handler: nil)
//    }

    func testWithoutProcess() {

        let expectation = expectationWithDescription("Process filter finished")
        ProcessFilter.processesWithIdentifiers([String]()) { (processes, error) -> Void in
            XCTAssertNil(error)
            XCTAssertEqual(processes!.count, 0)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }

    
}
