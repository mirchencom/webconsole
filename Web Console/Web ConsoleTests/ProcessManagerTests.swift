//
//  ProcessManagerTests.swift
//  Web Console
//
//  Created by Roben Kleene on 12/7/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest

@testable import Web_Console

class ProcessManagerTests: XCTestCase {

    // MARK: Properties

    class MockProcessManagerStore: ProcessManagerStore {
        let mutableDictionary = NSMutableDictionary()
        
        func setObject(value: AnyObject?, forKey defaultName: String) {
            mutableDictionary[defaultName] = value
        }
        
        func dictionaryForKey(defaultName: String) -> [String : AnyObject]? {
            return mutableDictionary[defaultName] as? [String : AnyObject]
        }
    }
    
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

    // MARK: Tests
    
    func testProcessManager() {
        let processInfo = ProcessInfo(identifier: 1,
            commandPath: "test",
            arguments: ["argument1", "argument2"],
            directoryPath: "/a_path/",
            startTime: NSDate())

        processManager.addProcessInfo(processInfo)
        let returnedProcessInfo = processManager.processInfoWithIdentifier(processInfo.identifier)!
        XCTAssertNotNil(returnedProcessInfo)
        XCTAssertEqual(processInfo, returnedProcessInfo)
    }

}