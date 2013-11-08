//
//  TaskHelper.h
//  Web Console
//
//  Created by Roben Kleene on 7/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskHelper : NSObject

/*! First interrupts an array of NSTasks, then terminates any NSTasks that did not terminate before timing out. Executes a handler block when all the NSTasks are terminated.
 * \param tasks An array of NSTasks to terminate.
 * \param completionHandler The handler block to execute.
 */
+ (void)terminateTasks:(NSArray *)tasks completionHandler:(void (^)(BOOL success))completionHandler;

@end
