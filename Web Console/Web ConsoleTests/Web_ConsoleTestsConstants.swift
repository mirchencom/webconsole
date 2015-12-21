//
//  TestConstants.swift
//  SplitViewPrototype
//
//  Created by Roben Kleene on 8/2/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

import Foundation

let testLogViewHeight = CGFloat(300)
let testLogViewHeightTwo = CGFloat(200)
let testTimeout = 2.0
let testFrame = NSMakeRect(200, 200, 500, 600)

// MARK: Test Data

let testDataSubdirectory = kTestDataSubdirectory

// MARK: Text Files

let testDataTextPSOutput = "ps_output"
let testDataTextExtension = "txt"

// MARK: HTML Files

let testDataHTMLFilename = kTestDataHTMLFilename
let testDataHTMLJQUERYFilename = kTestDataHTMLJQUERYFilename
let testDataHTMLJQUERYTitle = kTestDataHTMLJQUERYTitle
let testDataHTMLTitle = kTestDataHTMLTitle
let testDataHTMLExtension = kTestDataHTMLExtension
let testDataHTMLSubdirectory = kSharedTestResourcesHTMLSubdirectory

// MARK: JavaScript Files

let testDataJavaScriptTitleFilename = "title"
let testDataJavaScriptExtension = kTestDataJavaScriptExtension
let testDataJavaScriptSubdirectory = kSharedTestResourcesJavaScriptSubdirectory

// MARK: Ruby Files

let testDataRubyFileExtension =  kTestDataRubyExtension
let testDataSleepTwoSeconds = kTestDataSleepTwoSeconds
let testDataHelloWorld = kTestDataRubyHelloWorld

// MARK: Shell Scripts

let testDataShellScriptCatName = kTestDataCat
let testDataShellScriptExtension = kTestDataShellScriptExtension

// MARK: Plugins

let testPrintPluginName = kTestPrintPluginName
let testCatPluginName = kTestCatPluginName
let testHelloWorldPluginName = kTestHelloWorldPluginName
let testLogPluginName = "TestLog"
let testInvalidPluginName = "Invalid"
let testLogPluginErrorMessage = "Testing log error"
let testLogPluginInfoMessage = "Testing log message"

// MARK: JavaScript

let lastParagraphJavaScript = "document.querySelector('p:last-child').innerText;"
let firstParagraphJavaScript = "document.querySelector('p:first-child').innerText;"