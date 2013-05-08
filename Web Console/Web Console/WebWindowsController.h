//
//  WebWindowsController.h
//  Web Console
//
//  Created by Roben Kleene on 5/7/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WebWindowController.h"

@interface WebWindowsController : NSObject

+ (id)sharedWebWindowsController;
- (void)addWebWindowWithHTML:(NSString *)HTML;

@end
