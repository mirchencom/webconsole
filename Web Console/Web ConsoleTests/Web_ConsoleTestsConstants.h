//
//  Web_ConsoleTestsConstants.h
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#pragma mark - General

#define kRunLongTests YES
#define kTestTimeoutInterval 1
#define kTestLongTimeoutInterval 3


#pragma mark - Plugin

#define kTestPluginName @"Print"
#define kTestPluginCommand @"wcprint/wcprint.rb"
#define kPluginCommandPathKey @"commandPath"

#pragma mark - Window Sizes

#define kTestWindowFrame NSMakeRect(158, 97, 425, 450)
#define kTestWindowFrameTwo NSMakeRect(200, 200, 333, 388)

#pragma mark - Shared Resources

#define kTestSharedResourcePathComponent @"js/zepto.js"

#pragma mark - Shared Test Resources

#define kSharedTestResourcesPluginSubdirectory @"plugin"
#define kSharedTestResourcesJavaScriptSubdirectory @"js"
#define kSharedTestResourcesHTMLSubdirectory @"html"

#pragma mark - Test Data

#define kTestDataSubdirectory @"Data"

#pragma mark - HTML
#define kTestDataHTMLExtension @"html"
#pragma mark HTML Resources
#define kTestDataHTMLFilename @"index"
#define kTestDataHTMLTitle @"Index"
#define kTestDataHTMLJQUERYFilename @"indexjquery"
#define kTestDataHTMLJQUERYTitle @"Index JQuery"

#pragma mark - JavaScript
#define kTestDataJavaScriptExtension @"js"
#pragma mark JavaScript Resources
#define kTestJavaScriptTextJQueryFilename @"textjquery"
#define kTestJavaScriptTextFilename @"text"


#pragma mark - Ruby
#define kTestDataRubyExtension @"rb"
#pragma mark Ruby Resources
#define kTestDataRubyHelloWorld @"hello_world"
#define kTestDataSleepTwoSeconds @"sleep_two_seconds"


#pragma mark - Shell Scripts
#define kTestDataShellScriptExtension @"sh"
#define kTestDataInterruptFails @"interrupt_fails"
#define kTestDataCat @"cat"