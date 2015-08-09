//
//  WebWindowController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Plugin;

extern NSString * __nonnull const WCLSplitWebWindowControllerDidCancelCloseWindowNotification;

@interface WCLSplitWebWindowController : NSWindowController
@property (nonatomic, strong, nullable) Plugin *plugin;
@end
