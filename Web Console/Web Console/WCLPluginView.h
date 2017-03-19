//
//  WCLWebView.h
//  Web Console
//
//  Created by Roben Kleene on 8/25/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

@class Plugin;

NS_ASSUME_NONNULL_BEGIN
@protocol WCLPluginView <NSObject>
- (void)loadHTML:(NSString *)HTML
         baseURL:(NSURL *)baseURL
completionHandler:(nullable void (^)(BOOL success))completionHandler;
- (nullable NSString *)doJavaScript:(NSString *)javaScript;
- (void)readFromStandardInput:(NSString *)text;
- (void)runPlugin:(Plugin *)plugin
    withArguments:(nullable NSArray *)arguments
  inDirectoryPath:(nullable NSString *)directoryPath
completionHandler:(nullable void (^)(BOOL success))completionHandler;
@end
NS_ASSUME_NONNULL_END
