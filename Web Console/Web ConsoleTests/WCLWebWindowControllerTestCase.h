//
//  WCLWebWindowControllerTestCase.h
//  Web Console
//
//  Created by Roben Kleene on 12/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "XCTest+BundleResources.h"

#import "Web_ConsoleTestsConstants.h"

#import "WCLWebWindowsController.h"
#import "WCLWebWindowController.h"

@interface WCLWebWindowController (Tests)
@property (nonatomic, readonly) WebView *webView;
- (void)terminateTasksAndCloseWindow;
@end

@interface WCLWebWindowControllerTestCase : XCTestCase
- (NSString *)stringWithContentsOfSharedTestResource:(NSString *)filename
                                       withExtension:(NSString *)extension
                                        subdirectory:(NSString *)subdirectory;
@end