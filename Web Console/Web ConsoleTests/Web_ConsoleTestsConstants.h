//
//  Web_ConsoleTestsConstants.h
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WebWindowControllerTests.h"


#pragma mark - General

#define kTestTimeout 1


#pragma mark - Test Data

#define kTestDataSubdirectory @"Data"

#pragma mark Extensions
#define kTestDataHTMLExtension @"html"
#define kTestDataJavaScriptExtension @"js"

#pragma mark HTML Resources
#define kTestDataHTMLFilename @"index"
#define kTestDataHTMLJQUERYFilename @"indexjquery"

#pragma mark JavaScript Resources
#define kTestJavaScriptNoDOMFilename @"JavaScriptNoDOM"
#define kTestJavaScriptBodyJQueryFilename @"JavaScriptBodyJQuery"
#define kTestJavaScriptBodyFilename @"JavaScriptBody"
#define kTestJavaScriptTextJQueryFilename @"JavaScriptTextJQuery"
#define kTestJavaScriptTextFilename @"JavaScriptText"


#pragma mark - Plugins

#define kAllPlugins [kPlugins arrayByAddingObjectsFromArray:kTestPlugins]
#define kPlugins @[@"Ack"]
#define kTestPlugins @[@"NoWindowTest"]