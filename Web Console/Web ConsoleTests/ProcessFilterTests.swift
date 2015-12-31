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

    lazy var testProcessInfo: ProcessInfo = {
        let identifier = Int32(74)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss yyyy"
        let startTime = dateFormatter.dateFromString("Wed Dec 16 02:09:32 2015")!
        let commandPath = "/usr/libexec/wdhelper"
        return ProcessInfo(identifier: identifier, startTime: startTime, commandPath: commandPath)!
    }()
    
    // TODO: Start with one process, but we should do a test with several as well
    
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

    func testEmptyIdentifiers() {
        let expectation = expectationWithDescription("Process filter finished")
        ProcessFilter.processesWithIdentifiers([Int32]()) { (processes, error) -> Void in
            XCTAssertNotNil(error)
            XCTAssertNil(processes)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }

    func testEmptyInput() {
        var processInfos = ProcessFilter.processesFromOutput("")
        XCTAssertEqual(processInfos.count, 0)
        processInfos = ProcessFilter.processesFromOutput(" ")
        XCTAssertEqual(processInfos.count, 0)
    }
    
    func testExampleInput() {
        let fileURL = URLForResource(testDataTextPSOutputSmall,
            withExtension: testDataTextExtension,
            subdirectory: testDataSubdirectory)!
        
        let output = stringWithContentsOfFileURL(fileURL)!
        
        let processInfos = ProcessFilter.processesFromOutput(output)
        XCTAssertEqual(processInfos.count, 3)
        let processInfo = processInfos[0]

        XCTAssertEqual(processInfo.identifier, testProcessInfo.identifier)
        XCTAssertEqual(processInfo.startTime, testProcessInfo.startTime)
        XCTAssertEqual(processInfo.commandPath, testProcessInfo.commandPath)
    }

    func testBadExampleInput() {
        let fileURL = URLForResource(testDataTextPSOutputBad,
            withExtension: testDataTextExtension,
            subdirectory: testDataSubdirectory)!
        
        let output = stringWithContentsOfFileURL(fileURL)!
        
        let processInfos = ProcessFilter.processesFromOutput(output)
        XCTAssertEqual(processInfos.count, 1)
        let processInfo = processInfos[0]
        
        XCTAssertEqual(processInfo.identifier, testProcessInfo.identifier)
        XCTAssertEqual(processInfo.startTime, testProcessInfo.startTime)
        XCTAssertEqual(processInfo.commandPath, testProcessInfo.commandPath)
    }
    

}
