//
//  WCLTaskRunnerTaskResultTests.swift
//  Web Console
//
//  Created by Roben Kleene on 12/20/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest

@testable import Web_Console

class WCLTaskRunnerTaskResultTests: XCTestCase {
    
    func testInterruptTask() {
        
        let commandPath = pathForResource(testDataShellScriptCatName,
            ofType: testDataShellScriptExtension,
            inDirectory: testDataSubdirectory)!
        
        let expectation = expectationWithDescription("Task finished")

        WCLTaskRunner.runTaskUntilFinishedWithCommandPath(commandPath,
            withArguments: nil,
            inDirectoryPath: nil,
            timeout: 0.0)
        { (standardOutput, standardError, error) -> Void in

            XCTAssertNotNil(error)
            guard let error = error else {
                XCTAssertTrue(false)
                return
            }
            
            let description = error.userInfo[NSLocalizedDescriptionKey]!
            XCTAssertTrue(description.hasPrefix("An uncaught signal error occurred"))

            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(testTimeout, handler: nil)

    }
    

    func testStandardOutput() {
        
        let commandPath = pathForResource(testDataHelloWorld,
            ofType: testDataRubyFileExtension,
            inDirectory: testDataSubdirectory)!
        
        let expectation = expectationWithDescription("Task finished")
        
        WCLTaskRunner.runTaskUntilFinishedWithCommandPath(commandPath,
            withArguments: nil,
            inDirectoryPath: nil)
        { (standardOutput, standardError, error) -> Void in
                
                XCTAssertNil(error)
                guard let standardOutput = standardOutput else {
                    XCTAssertTrue(false)
                    return
                }

                NSLog("standardOutput = \(standardOutput)")

                expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }
}
