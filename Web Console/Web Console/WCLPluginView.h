//
//  WCLWebView.h
//  Web Console
//
//  Created by Roben Kleene on 8/25/15.
//  Copyright (c) 2015 Roben Kleene. All rights reserved.
//

@protocol WCLPluginView <NSObject>
- (void)loadHTML:(nonnull NSString *)HTML
         baseURL:(nullable NSURL *)baseURL
completionHandler:(nullable void (^)(BOOL success))completionHandler;
- (nullable NSString *)doJavaScript:(nonnull NSString *)javaScript;
@end