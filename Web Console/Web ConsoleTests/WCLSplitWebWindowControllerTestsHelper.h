//
//  WebWindowControllerTestsHelper.h
//  Web Console
//
//  Created by Roben Kleene on 10/21/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCLSplitWebWindowController;

@interface WCLSplitWebWindowControllerTestsHelper : NSObject
+ (void)blockUntilWebWindowControllerTasksRunAndFinish:(WCLSplitWebWindowController *)webWindowController;
+ (void)blockUntilWindowHasAttachedSheet:(NSWindow *)window;
+ (void)blockUntilWindowIsVisible:(NSWindow *)window;
+ (BOOL)windowWillCloseBeforeTimeout:(NSWindow *)window;
+ (void)closeWindowsAndBlockUntilFinished;
@end
