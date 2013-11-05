//
//  Web_ConsoleTestsConstants.h
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#pragma mark - General

#define kRunLongTests NO
#define kTestTimeoutInterval 1
#define kTestLongTimeoutInterval 3

#pragma mark - Plugin

#define kTestPluginName @"Ack"
#define kTestPluginCommand @"wcack/wcack.rb"




#pragma mark - Test Data

#define kTestDataSubdirectory @"Data"

#pragma mark - HTML
#define kTestDataHTMLExtension @"html"
#pragma mark HTML Resources
#define kTestDataHTMLFilename @"index"
#define kTestDataHTMLJQUERYFilename @"indexjquery"


#pragma mark - JavaScript
#define kTestDataJavaScriptExtension @"js"
#pragma mark JavaScript Resources
#define kTestJavaScriptNoDOMFilename @"JavaScriptNoDOM"
#define kTestJavaScriptBodyJQueryFilename @"JavaScriptBodyJQuery"
#define kTestJavaScriptBodyFilename @"JavaScriptBody"
#define kTestJavaScriptTextJQueryFilename @"JavaScriptTextJQuery"
#define kTestJavaScriptTextFilename @"JavaScriptText"


#pragma mark - Ruby
#define kTestDataRubyExtension @"rb"
#pragma mark Ruby Resources
#define kTestDataRubyHelloWorld @"hello_world"
#define kTestDataSleepTwoSeconds @"sleep_two_seconds"


#pragma mark - Shell Scripts
#define kTestDataShellScriptExtension @"sh"
#define kTestDataInterruptFails @"interrupt_fails"