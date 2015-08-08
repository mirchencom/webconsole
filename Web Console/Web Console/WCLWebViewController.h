//
//  WCLWebViewController.h
//  Web Console
//
//  Created by Roben Kleene on 8/7/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Plugin;
@class WCLWebViewController;

@protocol WCLWebViewControllerDelegate <NSObject>
- (NSNumber *)windowNumberForWebViewController:(WCLWebViewController *)webViewController;
@optional
- (void)webViewControllerViewWillAppear:(WCLWebViewController *)webViewController;
- (void)webViewControllerViewWillDisappear:(WCLWebViewController *)webViewController;
- (void)webViewControllerWillLoadHTML:(WCLWebViewController *)webViewController;
- (void)webViewController:(WCLWebViewController *)webViewController didReceiveTitle:(NSString *)title;
- (void)webViewController:(WCLWebViewController *)webViewController taskWillStart:(NSTask *)task;
- (void)webViewController:(WCLWebViewController *)webViewController taskDidFinish:(NSTask *)task;
@end

@interface WCLWebViewController : NSViewController
- (void)loadHTML:(NSString *)HTML completionHandler:(void (^)(BOOL success))completionHandler;
- (void)loadHTML:(NSString *)HTML baseURL:(NSURL *)baseURL completionHandler:(void (^)(BOOL success))completionHandler;
- (NSString *)doJavaScript:(NSString *)javaScript;
- (BOOL)hasTasks;
@property (nonatomic, strong, readonly) NSArray *tasks;
@property (nonatomic, strong) Plugin *plugin;
@property (nonatomic, weak) id<WCLWebViewControllerDelegate> delegate;
@end
