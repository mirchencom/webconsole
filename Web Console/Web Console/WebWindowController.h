//
//  WebWindowController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <WebKit/WebKit.h>

@class Plugin;

@interface WebWindowController : NSWindowController

/*! Load the HTML in the WebViewController's WebView and executes a handler block when the request completes or fails.
 * \param HTML The HTML string to load.
 * \param completionHandler The handler block to execute.
 */
- (void)loadHTML:(NSString *)HTML completionHandler:(void (^)(BOOL success))completionHandler;

/*! Load the HTML in the receiver's WebView and executes a handler block when the request completes or fails.
 * \param HTML The HTML string to load.
 * \param baseURL A file that is used to resolve relative URLs.
 * \param completionHandler The handler block to execute.
 */
- (void)loadHTML:(NSString *)HTML baseURL:(NSURL *)baseURL completionHandler:(void (^)(BOOL success))completionHandler;

/*! Returns the result of running a script in the receiver's WebView.
 * \param javaScript The script to run.
 * \return The result of running a JavaScript specified by script, or an empty string if the script failed.
 */
- (NSString *)doJavaScript:(NSString *)javaScript;

/*! Returns whether the receiver has tasks.
 * \return YES if the receiver has tasks, otherwise NO.
 */
- (BOOL)hasTasks;

/// An array of NSTasks the receiver is running.
@property (nonatomic, strong, readonly) NSArray *tasks;

/// The receiver's Plugin object.
@property (nonatomic, strong, readonly) Plugin *plugin;

@end