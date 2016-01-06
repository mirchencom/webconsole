//
//  NSError+WCLProcessKiller.h
//  Web Console
//
//  Created by Roben Kleene on 1/5/16.
//  Copyright © 2016 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCLProcessKiller: NSObject
+ (BOOL)killProcessWithIdentifier:(pid_t)processIdentifier;
@end