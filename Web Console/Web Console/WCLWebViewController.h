//
//  WCLWebViewController.h
//  Web Console
//
//  Created by Roben Kleene on 8/7/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "WCLPluginView.h"
#import "WCLTaskRunner.h"

@class Plugin;
@class WCLWebViewController;


NS_ASSUME_NONNULL_BEGIN
@protocol WCLWebViewControllerDelegate <NSObject>
#pragma mark - Data Source
- (NSWindow *)windowForWebViewController:(WCLWebViewController *)webViewController;
@optional
#pragma mark - Life Cycle
- (void)webViewControllerViewWillAppear:(WCLWebViewController *)webViewController;
- (void)webViewControllerViewWillDisappear:(WCLWebViewController *)webViewController;
#pragma mark - Events
- (void)webViewController:(WCLWebViewController *)webViewController
          didReceiveTitle:(NSString *)title;
- (void)webViewController:(WCLWebViewController *)webViewController
             willLoadHTML:(NSString *)HTML;
- (void)webViewController:(WCLWebViewController *)webViewController
         willDoJavaScript:(NSString *)javaScript;
- (void)webViewController:(WCLWebViewController *)webViewController
 didReadFromStandardInput:(NSString *)text;
- (void)webViewController:(WCLWebViewController *)webViewController
 didReceiveStandardOutput:(NSString *)text;
- (void)webViewController:(WCLWebViewController *)webViewController
  didReceiveStandardError:(NSString *)text;
#pragma mark - Starting & Finishing Tasks
- (void)webViewController:(WCLWebViewController *)webViewController
            willStartTask:(NSTask *)task;
- (void)webViewController:(WCLWebViewController *)webViewController
            didFinishTask:(NSTask *)task;
- (void)webViewController:(WCLWebViewController *)webViewController
         didFailToRunTask:(NSTask *)task
              commandPath:(NSString *)commandPath
                    error:(NSError *)error;
- (void)webViewController:(WCLWebViewController *)webViewController
        didRunCommandPath:(NSString *)commandPath
                arguments:(nullable NSArray<NSString *> *)arguments
            directoryPath:(nullable NSString *)directoryPath;
@end
NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN
@interface WCLWebViewController : NSViewController <WCLTaskRunnerDelegate, WCLPluginView>
- (BOOL)hasTasks;
@property (nonatomic, strong, readonly) NSArray<NSTask *> *tasks;
@property (nonatomic, strong, readonly, nullable) Plugin *plugin;
@property (nonatomic, weak, nullable) id<WCLWebViewControllerDelegate> delegate;
#pragma mark - AppleScript
@property (nonatomic, strong, readonly) NSString *identifier;
@end
NS_ASSUME_NONNULL_END
