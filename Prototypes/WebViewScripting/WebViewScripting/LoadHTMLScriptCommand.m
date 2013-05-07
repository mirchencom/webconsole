//
//  LoadHTMLScriptCommand.m
//  WebViewScripting
//
//  Created by Roben Kleene on 5/6/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "LoadHTMLScriptCommand.h"

@implementation LoadHTMLScriptCommand

- (id)performDefaultImplementation {
    NSLog(@"DirectParameterCommand performDefaultImplementation");
	
	NSLog(@"The direct parameter is: '%@'", [self directParameter]);
    
	return nil;
}

@end
