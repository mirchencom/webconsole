//
//  ApplicationTerminationHelper.h
//  Web Console
//
//  Created by Roben Kleene on 9/8/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationTerminationHelper : NSObject

+ (BOOL)applicationShouldTerminateAndManageWebWindowControllersWithTasks;

@end
