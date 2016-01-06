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
        return
        
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

        // Test that the `ProcessFilter` has the process

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
        
        // Test that the `ProcessFilter` does not have a process in the past

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
            XCTAssertNil(error)
            guard let identifierToProcessInfo = identifierToProcessInfo else {
                XCTAssertTrue(false)
                return
            }
            
            XCTAssertEqual(identifierToProcessInfo.count, 0)
            filterExpectationTwo.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)

        // Test that the `ProcessFilter` does have a process in the future
        
        let filterExpectationThree = expectationWithDescription("Process filter")
        
        let oneSecondInTheFuture = NSDate(timeIntervalSinceNow: 1.0)
        guard let inTheFutureProcessInfo = ProcessInfo(identifier: processInfo.identifier,
            startTime: oneSecondInTheFuture,
            commandPath: processInfo.commandPath) else
        {
            XCTAssertTrue(false)
            return
        }
        
        var runningProcessInfo: ProcessInfo!
        ProcessFilter.runningProcessMatchingProcessInfos([inTheFutureProcessInfo]) { (identifierToProcessInfo, error) -> Void in
            XCTAssertNil(error)
            guard let identifierToProcessInfo = identifierToProcessInfo,
                localRunningProcessInfo = identifierToProcessInfo[processInfo.identifier] else
            {
                XCTAssertTrue(false)
                return
            }
            
            XCTAssertEqual(localRunningProcessInfo.identifier, processInfo.identifier)
            runningProcessInfo = localRunningProcessInfo
            filterExpectationThree.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)

        // Terminate the process 
        
        let killProcessExpectation = expectationWithDescription("Kill process")
        ProcessKiller.killProcessInfo(runningProcessInfo) { success in
            killProcessExpectation.fulfill()
        }
        
        // Wait for the process to terminate

        // TODO: Migrate to `killProcessInfo` when a better implementation
        // of `killProcessInfo` exists. Really the completion handler of 
        // `killProcessInfo` not fire until the process has been terminated.
        let taskDidTerminateExpectation = expectationWithDescription("Task did terminate")
        var observer: NSObjectProtocol?
        observer = NSNotificationCenter.defaultCenter().addObserverForName(NSTaskDidTerminateNotification,
            object: task,
            queue: nil)
        { notification in
            if let observer = observer {
                NSNotificationCenter.defaultCenter().removeObserver(observer)
            }
            observer = nil
            taskDidTerminateExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout) { _ in
            if let observer = observer {
                NSNotificationCenter.defaultCenter().removeObserver(observer)
            }
            observer = nil
        }
        
        // Confirm the process has been removed
        
        let processInfosTwo = processManager.processInfos()
        XCTAssertEqual(processInfosTwo.count, 0)
        XCTAssertNil(processManager.processInfoWithIdentifier(task.processIdentifier))

        // Confirm that the `ProcessFilter` no longer has the process
        
        let filterExpectationFour = expectationWithDescription("Process filter")
        ProcessFilter.runningProcessMatchingProcessInfos([processInfo]) { (identifierToProcessInfo, error) -> Void in
            XCTAssertNil(error)
            guard let identifierToProcessInfo = identifierToProcessInfo else {
                XCTAssertTrue(false)
                return
            }
            
            XCTAssertEqual(identifierToProcessInfo.count, 0)
            filterExpectationFour.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
    }

}
