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

extern NSString * __nonnull const WCLSplitWebWindowControllerDidCancelCloseWindowNotification;

@protocol WCLSplitWebWindowControllerDelegate <NSObject>
@optional
- (void)splitWebWindowControllerWindowWillClose:(WCLSplitWebWindowController *)splitWebWindowController;
@end

@interface WCLSplitWebWindowController : NSWindowController
@property (nonatomic, weak, nullable) id<WCLSplitWebWindowControllerDelegate> delegate;
@property (nonatomic, strong, nullable) Plugin *plugin;
@end
