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
    // TODO: Do a test with several processess
    // * Also should do a function like `runningProcessesMatchingProcessInfos`
    
    func testWithProcess() {
        
        let commandPath = pathForResource(testDataShellScriptCatName,
            ofType: testDataShellScriptExtension,
            inDirectory: testDataSubdirectory)!
        
        let runExpectation = expectationWithDescription("Task ran")
        let task = WCLTaskRunner.runTaskWithCommandPath(commandPath,
            withArguments: nil,
            inDirectoryPath: nil,
            delegate: nil)
        { (success) -> Void in
            XCTAssertTrue(success)
            runExpectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(testTimeout, handler: nil)


        // Clean up

        let interruptExpectation = expectationWithDescription("Interrupt finished")
        task.wcl_interruptWithCompletionHandler { (success) -> Void in
            XCTAssertTrue(success)
            interruptExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}

class ProcessFilterNoProcessTests: XCTestCase {

    lazy var testProcessInfo: ProcessInfo = {
        let identifier = Int32(74)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE MMM d HH:mm:ss yyyy"
        let startTime = dateFormatter.dateFromString("Wed Dec 16 02:09:32 2015")!
        let commandPath = "/usr/libexec/wdhelper"
        return ProcessInfo(identifier: identifier, startTime: startTime, commandPath: commandPath)!
    }()

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
