//
//  AppleScriptHelper.h
//  Web Console
//
//  Created by Roben Kleene on 6/18/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppleScriptHelper : NSObject
+ (NSAppleEventDescriptor *)resultOfRunningTestScriptWithName:(NSString *)name parameters:(NSAppleEventDescriptor *)parameters;
@end