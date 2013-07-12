//
//  WebWindowController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <WebKit/WebKit.h>

@interface WebWindowController : NSWindowController
- (void)loadHTML:(NSString *)HTML completionHandler:(void (^)(BOOL success))completionHandler;
- (void)loadHTML:(NSString *)HTML baseURL:(NSURL *)baseURL completionHandler:(void (^)(BOOL success))completionHandler;
- (NSString *)doJavaScript:(NSString *)javaScript;
@property (nonatomic, strong) NSMutableArray *tasks;
@end
