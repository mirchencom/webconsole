//
//  ProcessIntegrationTest.swift
//  Web Console
//
//  Created by Roben Kleene on 1/1/16.
//  Copyright © 2016 Roben Kleene. All rights reserved.
//

import XCTest

@testable import Web_Console

class ProcessManagerRouter: NSObject, WCLTaskRunnerDelegate {

    let processManager: ProcessManager
    
    init(processManager: ProcessManager) {
        self.processManager = processManager
    }
    
    // MARK: WCLTaskRunnerDelegate
    
    func taskDidFinish(task: NSTask) {
        processManager.removeProcessWithIdentifier(task.processIdentifier)
    }
    
    func task(task: NSTask,
        didRunCommandPath commandPath: String,
        arguments: [String]?,
        directoryPath: String?)
    {
        if let
            commandPath = task.launchPath,
            processInfo = ProcessInfo(identifier: task.processIdentifier,
                startTime: NSDate(),
                commandPath: commandPath)
        {
            processManager.addProcessInfo(processInfo)
        }
    }
    
}

class OneProcessIntegrationTests: ProcessManagerTestCase {

    var processManagerRouter: ProcessManagerRouter!
    var task: NSTask!
    
    // MARK: setUp & tearDown
    
    override func setUp() {
        super.setUp()
        processManagerRouter = ProcessManagerRouter(processManager: processManager)
    }
    
    override func tearDown() {
        processManagerRouter = nil
        super.tearDown()
    }
    
    // MARK: Tests
    
    func testProcess() {
        let commandPath = pathForResource(testDataShellScriptCatName,
            ofType: testDataShellScriptExtension,
            inDirectory: testDataSubdirectory)!
        
        let runExpectation = expectationWithDescription("Task ran")
        task = WCLTaskRunner.runTaskWithCommandPath(commandPath,
            withArguments: nil,
            inDirectoryPath: nil,
            delegate: processManagerRouter)
            { (success) -> Void in
                
                XCTAssertTrue(success)
                runExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        
        // Test that the `ProcessManager` has the process

        let processInfos = processManager.processInfos()
        XCTAssertEqual(processInfos.count, 1)
        let processInfo = processInfos[0]
        let processInfoByIdentifier = processManager.processInfoWithIdentifier(task.processIdentifier)
        XCTAssertEqual(processInfo, processInfoByIdentifier)
        XCTAssertEqual(processInfo.identifier, task.processIdentifier)

        // Test that the process filter has the process

        let filterExpectation = expectationWithDescription("Process filter")
        ProcessFilter.runningProcessMatchingProcessInfos([processInfo]) { (identifierToProcessInfo, error) -> Void in
            XCTAssertNil(error)
            guard let identifierToProcessInfo = identifierToProcessInfo,
                runningProcessInfo = identifierToProcessInfo[processInfo.identifier] else
            {
                XCTAssertTrue(false)
                return
            }
            
            XCTAssertEqual(runningProcessInfo.identifier, processInfo.identifier)
            filterExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        
        // Test that the process filter does not have a process in the past

        let filterExpectationTwo = expectationWithDescription("Process filter")

        let oneSecondInThePast = NSDate(timeIntervalSinceNow: -1.0)
        guard let inThePastProcessInfo = ProcessInfo(identifier: processInfo.identifier,
            startTime: oneSecondInThePast,
            commandPath: processInfo.commandPath) else
        {
            XCTAssertTrue(false)
            return
        }

        ProcessFilter.runningProcessMatchingProcessInfos([inThePastProcessInfo]) { (identifierToProcessInfo, error) -> Void in
            guard let identifierToProcessInfo = identifierToProcessInfo else {
                XCTAssertTrue(false)
                return
            }
            
            XCTAssertEqual(identifierToProcessInfo.count, 0)
            filterExpectationTwo.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)

        // Test that the process filter does have a process in the future
        
        let filterExpectationThree = expectationWithDescription("Process filter")
        
        let oneSecondInTheFuture = NSDate(timeIntervalSinceNow: 1.0)
        guard let inTheFutureProcessInfo = ProcessInfo(identifier: processInfo.identifier,
            startTime: oneSecondInTheFuture,
            commandPath: processInfo.commandPath) else
        {
            XCTAssertTrue(false)
            return
        }
        
        ProcessFilter.runningProcessMatchingProcessInfos([inTheFutureProcessInfo]) { (identifierToProcessInfo, error) -> Void in
            XCTAssertNil(error)
            guard let identifierToProcessInfo = identifierToProcessInfo,
                runningProcessInfo = identifierToProcessInfo[processInfo.identifier] else
            {
                XCTAssertTrue(false)
                return
            }
            
            XCTAssertEqual(runningProcessInfo.identifier, processInfo.identifier)
            filterExpectationThree.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)

        // Clean up
        
        // Note: This is temporary, this will probably be replaced with a
        // separate cancel function that doesn't rely on having an existing
        // `NSTask` since we won't have one normally
        
        let interruptExpectation = expectationWithDescription("Interrupt finished")
        task.wcl_interruptWithCompletionHandler { (success) -> Void in
            XCTAssertTrue(success)
            interruptExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        
        // Confirm the process has been removed
        
        let processInfosTwo = processManager.processInfos()
        XCTAssertEqual(processInfosTwo.count, 0)
        XCTAssertNil(processManager.processInfoWithIdentifier(task.processIdentifier))
    }

}
