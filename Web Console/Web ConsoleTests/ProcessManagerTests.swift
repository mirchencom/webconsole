//
//  ProcessManagerTests.swift
//  Web Console
//
//  Created by Roben Kleene on 12/7/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest

@testable import Web_Console

class ProcessManagerTestCase: XCTestCase {
    class MockProcessManagerStore: ProcessManagerStore {
        let mutableDictionary = NSMutableDictionary()
        
        func setObject(value: AnyObject?, forKey defaultName: String) {
            mutableDictionary[defaultName] = value
        }
        
        func dictionaryForKey(defaultName: String) -> [String : AnyObject]? {
            return mutableDictionary[defaultName] as? [String : AnyObject]
        }
    }
    
    // MARK: Properties
    
    var processManagerStore: ProcessManagerStore!
    var processManager: ProcessManager!
    
    // MARK: Setup & Teardown

    override func setUp() {
        super.setUp()
        processManagerStore = MockProcessManagerStore()
        processManager = ProcessManager(processManagerStore: processManagerStore)
    }
    
    override func tearDown() {
        super.tearDown()
        processManager = nil
    }

}

class ProcessManagerTests: ProcessManagerTestCase {

    func testProcessManager() {
        let processInfo = ProcessInfo(identifier: 1,
            startTime: NSDate(),
            commandPath: "test")!

        let testProcessManager: (processManager: ProcessManager) -> Bool = { processManager in
            let returnedProcessInfo = processManager.processInfoWithIdentifier(processInfo.identifier)!
            XCTAssertNotNil(returnedProcessInfo)
            XCTAssertEqual(returnedProcessInfo, processInfo)
            
            let returnedProcessInfos = processManager.processInfos()
            XCTAssertEqual(returnedProcessInfos.count, 1)
            XCTAssertEqual(returnedProcessInfos[0], processInfo)
            
            let invalidProcessInfo = processManager.processInfoWithIdentifier(999)
            XCTAssertNil(invalidProcessInfo)
            return true
        }
        
        processManager.addProcessInfo(processInfo)
        let processManagerResult = testProcessManager(processManager: processManager)
        XCTAssertTrue(processManagerResult)
        
        // Initialize a second `ProcessManager` with the existing `ProcessManagerStore`
        // this will test that the new `ProcessManager` is initialized with the
        // `ProcessInfo`s already stored in the `ProcessManagerStore`.
        let processManagerTwo = ProcessManager(processManagerStore: processManagerStore)
        let processManagerTwoResult = testProcessManager(processManager: processManagerTwo)
        XCTAssertTrue(processManagerTwoResult)
        
        // TODO: Remove the processes, then make sure it returns nil
        // TODO: Init and make sure it returns nil
        
    
    }

}