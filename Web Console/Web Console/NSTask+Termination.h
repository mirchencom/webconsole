//
//  NSTask+TerminationAdditions.h
//  Web Console
//
//  Created by Roben Kleene on 7/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTask (Termination)

/*! Sends an interrupt signal to the receiver and all of its subtasks and executes a handler block when the task terminates or after a timeout.
 * \param completionHandler A handler block execute.
 */
- (void)interruptWithCompletionHandler:(void (^)(BOOL success))completionHandler;

/*! Sends an terminate signal to the receiver and all of its subtasks and executes a handler block when the task terminates or after a timeout.
 * \param completionHandler A handler block execute.
 */
- (void)terminateWithCompletionHandler:(void (^)(BOOL success))completionHandler;

@end