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
    
    var processManager: ProcessManager!
    
    // MARK: Setup & Teardown

    override func setUp() {
        super.setUp()
        processManager = ProcessManager(processManagerStore: MockProcessManagerStore())
    }
    
    override func tearDown() {
        super.tearDown()
        processManager = ProcessManager(processManagerStore: MockProcessManagerStore())
    }

}

class ProcessManagerTests: ProcessManagerTestCase {

    func testProcessManager() {
        let processInfo = ProcessInfo(identifier: 1,
            startTime: NSDate(),
            commandPath: "test")!

        processManager.addProcessInfo(processInfo)
        let returnedProcessInfo = processManager.processInfoWithIdentifier(processInfo.identifier)!
        XCTAssertNotNil(returnedProcessInfo)
        XCTAssertEqual(returnedProcessInfo, processInfo)

        let returnedProcessInfos = processManager.processInfos()
        XCTAssertEqual(returnedProcessInfos.count, 1)
        XCTAssertEqual(returnedProcessInfos[0], processInfo)
        
        let invalidProcessInfo = processManager.processInfoWithIdentifier(999)
        XCTAssertNil(invalidProcessInfo)

        // We could do the process info initialization test here by grabbing the
        // dictionary, initializing a new `ProcessManager` with it, and then 
        // running the above asserts again

//        let processManagerStore = processManager.processManagerStore
//        let processManagerTwo = ProcessManager(processManagerStore: processManagerStore)
    }

    // TODO: Write a test where a `ProcessInfo` is added independently to the
    // `ProcessManagerStore` before initializing the `ProcessManager`, and
    // assure that `ProcessInfo` is there on startup.
}