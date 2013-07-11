//
//  TaskWrapper.h
//  StandardInputTest
//
//  Created by Roben Kleene on 7/10/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskWrapper : NSObject

- (void)passTextToCommand:(NSString *)text;
- (void)runCommandAtPath:(NSString *)commandPath;

@end
