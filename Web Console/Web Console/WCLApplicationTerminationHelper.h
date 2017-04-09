//
//  ApplicationTerminationHelper.h
//  Web Console
//
//  Created by Roben Kleene on 9/8/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface WCLApplicationTerminationHelper : NSObject
/*! Returns whether the application should terminate, and manages replyToApplicationShouldTerminate:.
 * \return YES if the application should terminate, otherwise NO.
 */
+ (BOOL)applicationShouldTerminateAndManageWebWindowControllersWithTasks;
@end
NS_ASSUME_NONNULL_END
