//
//  NSTask+TerminationAdditions.h
//  Web Console
//
//  Created by Roben Kleene on 7/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTask (Termination)
- (void)interruptWithCompletionHandler:(void (^)(BOOL success))completionHandler;
- (void)terminateWithCompletionHandler:(void (^)(BOOL success))completionHandler;
- (void)terminateUseInterrupt:(BOOL)useInterrupt completionHandler:(void (^)(BOOL success))completionHandler;
@end