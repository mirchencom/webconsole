//
//  WebWindowController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Plugin;
@class WCLSplitWebWindowController;
@class SplitWebViewController;

extern NSString * __nonnull const WCLSplitWebWindowControllerDidCancelCloseWindowNotification;

@protocol WCLSplitWebWindowControllerDelegate <NSObject>
@optional
- (void)splitWebWindowControllerWindowWillClose:(nonnull WCLSplitWebWindowController *)splitWebWindowController;
@end

@interface WCLSplitWebWindowController : NSWindowController
@property (nonatomic, weak, nullable) id<WCLSplitWebWindowControllerDelegate> delegate;
@property (nonatomic, strong, readonly, nullable) Plugin *plugin;
@property (nonnull, readonly) SplitWebViewController *splitWebViewController;
#pragma mark - AppleScript
- (void)loadHTML:(nonnull NSString *)HTML
         baseURL:(nullable NSURL *)baseURL
completionHandler:(nullable void (^)(BOOL success))completionHandler;
- (nullable NSString *)doJavaScript:(nonnull NSString *)javaScript;
- (void)readFromStandardInput:(nonnull NSString *)text;
- (void)runPlugin:(nonnull Plugin *)plugin
    withArguments:(nullable NSArray *)arguments
  inDirectoryPath:(nullable NSString *)directoryPath
completionHandler:(nullable void (^)(BOOL success))completionHandler;
- (nonnull NSArray *)webViewControllers;
#pragma mark - Tasks
- (BOOL)hasTasks;
- (nonnull NSArray *)tasks;
@end