//
//  Plugin+Tests.h
//  Web Console
//
//  Created by Roben Kleene on 11/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "Plugin.h"

@interface Plugin (Tests)
- (void)runCommandPath:(NSString *)commandPath
         withArguments:(NSArray *)arguments
      withResourcePath:(NSString *)resourcePath
       inDirectoryPath:(NSString *)directoryPath;
@end