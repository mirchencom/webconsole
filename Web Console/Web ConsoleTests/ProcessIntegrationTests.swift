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

    func testProcess() {
    
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

        NSLog("task = \(task)")

    
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

    }

}
