//
//  RubyTestUnit.h
//  RubyUnitTests
//
//  Created by Roben Kleene on 6/29/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RubyTestUnit : NSObject

+ (void)runTestWithContentsOfURL:(NSURL *)URL completionHandler:(void (^)(BOOL success))completionHandler;

@end
