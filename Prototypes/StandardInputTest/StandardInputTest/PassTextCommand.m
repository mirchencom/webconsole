//
//  PassTextCommand.m
//  StandardInputTest
//
//  Created by Roben Kleene on 7/9/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "PassTextCommand.h"

@implementation PassTextCommand

- (id)performDefaultImplementation {

    NSString *text = [self directParameter];

    NSLog(@"text = %@", text);

    return nil;
}
@end
