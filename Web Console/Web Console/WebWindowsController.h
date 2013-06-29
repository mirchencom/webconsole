//
//  WebWindowsController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebWindowController;

@interface WebWindowsController : NSObject

+ (id)sharedWebWindowsController;
- (WebWindowController *)addedWebWindowController;
- (void)removeWebWindowController:(WebWindowController *)webWindowController;
@end