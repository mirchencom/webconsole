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

class ProcessIntegrationTests: ProcessManagerTestCase {

    var processManagerRouter: ProcessManagerRouter!
    
    // MARK: setUp & tearDown
    
    override func setUp() {
        super.setUp()
        processManagerRouter = ProcessManagerRouter(processManager: processManager)
    }
    
    override func tearDown() {
        super.tearDown()
        processManagerRouter = nil
    }
    
    // MARK: Tests
    
    func testProcess() {
    
        let commandPath = pathForResource(testDataShellScriptCatName,
            ofType: testDataShellScriptExtension,
            inDirectory: testDataSubdirectory)!
        
        let runExpectation = expectationWithDescription("Task ran")
        let task = WCLTaskRunner.runTaskWithCommandPath(commandPath,
            withArguments: nil,
            inDirectoryPath: nil,
            delegate: processManagerRouter)
        { (success) -> Void in
            
            XCTAssertTrue(success)
            runExpectation.fulfill()
        }

        waitForExpectationsWithTimeout(testTimeout, handler: nil)

        let processInfos = processManager.processInfos()
        XCTAssertEqual(processInfos.count, 1)
        let processInfo = processInfos[0]
        let processInfoByIdentifier = processManager.processInfoWithIdentifier(task.processIdentifier)
        XCTAssertEqual(processInfo, processInfoByIdentifier)
        XCTAssertEqual(processInfo.identifier, task.processIdentifier)
        
        // Interrupt the process

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
