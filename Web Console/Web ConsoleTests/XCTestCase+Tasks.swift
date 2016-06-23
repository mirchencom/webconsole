//
//  TaskHelper.swift
//  Web Console
//
//  Created by Roben Kleene on 1/7/16.
//  Copyright © 2016 Roben Kleene. All rights reserved.
//

import Foundation

extension XCTestCase {
    func waitForTasksToTerminate(tasks: [NSTask]) {
        var expectation: XCTestExpectation?
        let observers = NSMutableArray()
        
        for task in tasks {
            if !task.running {
                continue
            }

            if expectation == nil {
                expectation = expectationWithDescription("Tasks terminated")
            }

            let clearObserver: (NSObjectProtocol) -> () = { observer in
                NSNotificationCenter.defaultCenter().removeObserver(observer)
                observers.removeObject(observer)
                if let expectation = expectation where observers.count == 0 {
                    expectation.fulfill()
                }
            }
        
            var observer: NSObjectProtocol?
            observer = NSNotificationCenter.defaultCenter().addObserverForName(NSTaskDidTerminateNotification,
                object: task,
                queue: nil)
                { notification in
                    if let observer = observer {
                        clearObserver(observer)
                    }
            }
            
            if let observer = observer {
                observers.addObject(observer)
                if !task.running {
                    clearObserver(observer)
                }
            }

        }

        waitForExpectationsWithTimeout(testTimeout) { _ in
            let allObservers = Array(observers)
            for observer in allObservers {
                observers.removeObject(observer)
                NSNotificationCenter.defaultCenter().removeObserver(observer)
            }
        }

    }
}
