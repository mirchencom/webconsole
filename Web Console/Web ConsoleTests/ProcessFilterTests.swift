//
//  ProcessFilterTests.swift
//  Web Console
//
//  Created by Roben Kleene on 12/9/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest

@testable import Web_Console

// MARK: ProcessFilterTests

class ProcessFilterTests: XCTestCase {
    
    func testWithProcesses() {

        var tasks = [NSTask]()
        for _ in 0...2 {
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
            tasks.append(task)
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        
        let taskIdentifiers = tasks.map { $0.processIdentifier }.sort { $0 < $1 }
        let processFilterExpectation = expectationWithDescription("Filter processes")
        ProcessFilter.runningProcessesWithIdentifiers(taskIdentifiers) { (identifierToProcessInfo, error) -> Void in
            guard let identifierToProcessInfo = identifierToProcessInfo else {
                XCTAssertTrue(false)
                return
            }
            XCTAssertNil(error)

            XCTAssertEqual(identifierToProcessInfo.count, 3)
 
            let processIdentifiers = identifierToProcessInfo.values.map({ $0.identifier }).sort { $0 < $1 }
            XCTAssertEqual(processIdentifiers, taskIdentifiers)
            processFilterExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        
        // Clean up

        for task in tasks {
            let interruptExpectation = expectationWithDescription("Interrupt finished")
            task.wcl_interruptWithCompletionHandler { (success) -> Void in
                XCTAssertTrue(success)
                interruptExpectation.fulfill()
            }
        }

        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }
    
    
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
        
        let processFilterExpectation = expectationWithDescription("Filter processes")
        ProcessFilter.runningProcessesWithIdentifiers([task.processIdentifier]) { (identifierToProcessInfo, error) -> Void in
            XCTAssertNil(error)
            XCTAssertNotNil(identifierToProcessInfo)
            guard let identifierToProcessInfo = identifierToProcessInfo else {
                XCTAssertTrue(false)
                return
            }
            
            XCTAssertEqual(identifierToProcessInfo.count, 1)
            guard let processInfo = identifierToProcessInfo[task.processIdentifier] else {
                XCTAssertTrue(false)
                return
            }
            XCTAssertEqual(processInfo.identifier, task.processIdentifier)
            processFilterExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        
        // Clean up

        let interruptExpectation = expectationWithDescription("Interrupt finished")
        task.wcl_interruptWithCompletionHandler { (success) -> Void in
            XCTAssertTrue(success)
            interruptExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }
}


// MARK: ProcessFilterNoProcessTests

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
        ProcessFilter.runningProcessesWithIdentifiers([Int32]()) { (identifierToProcessInfo, error) -> Void in
            XCTAssertNotNil(error)
            XCTAssertNil(identifierToProcessInfo)
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
        
        let identifierToProcessInfo = ProcessFilter.processesFromOutput(output)
        XCTAssertEqual(identifierToProcessInfo.count, 3)
        guard let processInfo = identifierToProcessInfo[testProcessInfo.identifier] else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(processInfo.identifier, testProcessInfo.identifier)
        XCTAssertEqual(processInfo.startTime, testProcessInfo.startTime)
        XCTAssertEqual(processInfo.commandPath, testProcessInfo.commandPath)
    }

    func testBadExampleInput() {
        let fileURL = URLForResource(testDataTextPSOutputBad,
            withExtension: testDataTextExtension,
            subdirectory: testDataSubdirectory)!
        
        let output = stringWithContentsOfFileURL(fileURL)!
        
        let identifierToProcessInfo = ProcessFilter.processesFromOutput(output)
        XCTAssertEqual(identifierToProcessInfo.count, 1)
        guard let processInfo = identifierToProcessInfo[testProcessInfo.identifier] else {
            XCTAssertTrue(false)
            return
        }

        XCTAssertEqual(processInfo.identifier, testProcessInfo.identifier)
        XCTAssertEqual(processInfo.startTime, testProcessInfo.startTime)
        XCTAssertEqual(processInfo.commandPath, testProcessInfo.commandPath)
    }
    

}
