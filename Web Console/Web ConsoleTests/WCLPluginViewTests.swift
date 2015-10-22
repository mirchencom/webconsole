//
//  WCLPluginViewTests.swift
//  Web Console
//
//  Created by Roben Kleene on 10/20/15.
//  Copyright © 2015 Roben Kleene. All rights reserved.
//

import XCTest

class WCLPluginViewTests: WCLSplitWebWindowControllerTestCase {

    var splitWebWindowController: WCLSplitWebWindowController!
    var splits: [WCLPluginView]!
    
    // MARK: Setup & Teardown
    
    override func setUp() {
        super.setUp()
        splitWebWindowController = makeSplitWebWindowController()
        splits = splitWebWindowController.window!.splits()
        XCTAssertEqual(splits.count, 2, "There should be two splits")
    }
    
    override func tearDown() {
        splitWebWindowController = nil
        super.tearDown()
    }

    // MARK: Tests
    
    func testLoadHTMLInSplits() {
        // Load the HTML in the first split
        let split = splits[0]
        let HTML = self.dynamicType.wcl_stringWithContentsOfSharedTestResource(testDataHTMLFilename,
            withExtension: testDataHTMLExtension,
            subdirectory: sharedTestResourcesHTMLSubdirectory)
        let baseURL = self.dynamicType.wcl_sharedTestResourcesURL()
        let HTMLLoadExpectation = expectationWithDescription("HTML Load")
        split.loadHTML(HTML, baseURL: baseURL) { success in
            HTMLLoadExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        
        // Test the title
        let titleJavaScript = self.dynamicType.wcl_stringWithContentsOfSharedTestResource(testDataJavaScriptTitleFilename,
            withExtension: testDataJavaScriptExtension,
            subdirectory: sharedTestResourcesJavaScriptSubdirectory)
        var title = split.doJavaScript(titleJavaScript)
        XCTAssertEqual(title, testDataHTMLTitle, "The titles should be equal")
        XCTAssertEqual(splitWebWindowController.window!.title, testDataHTMLTitle, "The titles should be equal")

        
        
        // Load the HTML in the second split
        let splitTwo = splits[1]
        let HTMLTwo = self.dynamicType.wcl_stringWithContentsOfSharedTestResource(testDataHTMLJQUERYFilename,
            withExtension: testDataHTMLExtension,
            subdirectory: sharedTestResourcesHTMLSubdirectory)
        let HTMLTwoLoadExpectation = expectationWithDescription("HTML Load Two")
        splitTwo.loadHTML(HTMLTwo, baseURL: baseURL) { success in
            HTMLTwoLoadExpectation.fulfill()
        }
        waitForExpectationsWithTimeout(testTimeout, handler: nil)
        
        // Test the second title
        let titleTwo = splitTwo.doJavaScript(titleJavaScript)
        XCTAssertEqual(titleTwo, testDataHTMLJQUERYTitle, "The titles should be equal")
        
        // Test the title in the first window again
        title = split.doJavaScript(titleJavaScript)
        XCTAssertEqual(title, testDataHTMLTitle, "The titles should be equal")
        XCTAssertEqual(splitWebWindowController.window!.title, testDataHTMLTitle, "The titles should be equal")
    }
}
