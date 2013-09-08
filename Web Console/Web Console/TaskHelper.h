//
//  TaskHelper.h
//  Web Console
//
//  Created by Roben Kleene on 7/20/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskHelper : NSObject
+ (void)terminateTasks:(NSArray *)tasks completionHandler:(void (^)(BOOL success))completionHandler;
@end
