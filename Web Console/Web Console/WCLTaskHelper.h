//
//  TaskHelper.h
//  Web Console
//
//  Created by Roben Kleene on 7/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCLTaskHelper : NSObject

/*! First interrupts an array of NSTasks, then terminates any NSTasks that did not terminate before timing out. Executes a handler block when all the NSTasks are terminated.
 * \param tasks An array of NSTasks to terminate.
 * \param completionHandler The handler block to execute.
 */
+ (void)terminateTask:(nonnull NSTask *)task
    completionHandler:(nullable void (^)(BOOL success))completionHandler;
+ (void)terminateTasks:(nonnull NSArray<NSTask *> *)tasks
     completionHandler:(nullable void (^)(BOOL success))completionHandler;

@end
