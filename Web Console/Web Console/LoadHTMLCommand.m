//
//  LoadHTMLCommand.m
//  Web Console
//
//  Created by Roben Kleene on 6/17/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "LoadHTMLCommand.h"

#import "WebWindowsController.h"
#import "WebWindowController.h"

@implementation LoadHTMLCommand
- (id)performDefaultImplementation {
    NSLog(@"The direct parameter is: '%@'", [self directParameter]);
    WebWindowController *webWindowController = [[WebWindowsController sharedWebWindowsController] addWebWindowWithHTML:[self directParameter]];

    return webWindowController.window;
}
@end
