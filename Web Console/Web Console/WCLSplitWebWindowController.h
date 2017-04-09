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
@class WCLWebViewController;

extern NSString * __nonnull const WCLSplitWebWindowControllerDidCancelCloseWindowNotification;

NS_ASSUME_NONNULL_BEGIN
@protocol WCLSplitWebWindowControllerDelegate <NSObject>
@optional
- (void)splitWebWindowControllerWindowWillClose:(WCLSplitWebWindowController *)splitWebWindowController;
- (nullable Plugin *)logPluginForSplitWebWindowController:(WCLSplitWebWindowController *)splitWebViewController;
@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface WCLSplitWebWindowController : NSWindowController
@property (nonatomic, weak, nullable) id<WCLSplitWebWindowControllerDelegate> delegate;
@property (nonatomic, strong, readonly, nullable) Plugin *plugin;
#pragma mark - AppleScript
- (void)loadHTML:(NSString *)HTML
         baseURL:(nullable NSURL *)baseURL
completionHandler:(nullable void (^)(BOOL success))completionHandler;
- (nullable NSString *)doJavaScript:(NSString *)javaScript;
- (void)readFromStandardInput:(NSString *)text;
- (void)runPlugin:(Plugin *)plugin
    withArguments:(nullable NSArray *)arguments
  inDirectoryPath:(nullable NSString *)directoryPath
completionHandler:(nullable void (^)(BOOL success))completionHandler;
- (NSArray<WCLWebViewController *> *)webViewControllers;
- (void)showLog;
- (void)hideLog;
- (void)toggleLog;
#pragma mark - Tasks
- (BOOL)hasTasks;
- (BOOL)hasTasksRequiringConfirmation;
- (NSArray<NSTask *> *)tasks;
@end
NS_ASSUME_NONNULL_END
