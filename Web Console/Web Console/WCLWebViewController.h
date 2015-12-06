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

@protocol WCLWebViewControllerDelegate <NSObject>
#pragma mark - Data Source
- (nonnull NSWindow *)windowForWebViewController:(nonnull WCLWebViewController *)webViewController;
@optional
#pragma mark - Life Cycle
- (void)webViewControllerViewWillAppear:(nonnull WCLWebViewController *)webViewController;
- (void)webViewControllerViewWillDisappear:(nonnull WCLWebViewController *)webViewController;
#pragma mark - Events
- (void)webViewController:(nonnull WCLWebViewController *)webViewController
          didReceiveTitle:(nonnull NSString *)title;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController
             willLoadHTML:(nonnull NSString *)HTML;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController
         willDoJavaScript:(nonnull NSString *)javaScript;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController
 didReadFromStandardInput:(nonnull NSString *)text;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController
 didReceiveStandardOutput:(nonnull NSString *)text;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController
  didReceiveStandardError:(nonnull NSString *)text;
#pragma mark - Starting & Finishing Tasks
- (void)webViewController:(nonnull WCLWebViewController *)webViewController
            willStartTask:(nonnull NSTask *)task;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController
            didFinishTask:(nonnull NSTask *)task;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController
         didFailToRunTask:(nonnull NSTask *)task
              commandPath:(nonnull NSString *)commandPath
                    error:(nonnull NSError *)error;
- (void)webViewController:(nonnull WCLWebViewController *)webViewController
        didRunCommandPath:(nonnull NSString *)commandPath
                arguments:(nullable NSArray<NSString *> *)arguments
            directoryPath:(nullable NSString *)directoryPath;
@end

@interface WCLWebViewController : NSViewController <WCLTaskRunnerDelegate, WCLPluginView>
- (BOOL)hasTasks;
@property (nonatomic, strong, readonly, nonnull) NSArray<NSTask *> *tasks;
@property (nonatomic, strong, readonly, nullable) Plugin *plugin;
@property (nonatomic, weak, nullable) id<WCLWebViewControllerDelegate> delegate;
#pragma mark - AppleScript
@property (nonatomic, strong, readonly, nonnull) NSString *identifier;
@end
