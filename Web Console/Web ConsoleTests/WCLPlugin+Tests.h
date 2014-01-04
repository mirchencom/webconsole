//
//  Plugin+Tests.h
//  Web Console
//
//  Created by Roben Kleene on 11/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WCLPlugin.h"

@interface WCLPlugin (Tests)
- (void)runCommandPath:(NSString *)commandPath
         withArguments:(NSArray *)arguments
       inDirectoryPath:(NSString *)directoryPath;
- (NSString *)commandPath;
- (NSString *)command;
- (void)readFromStandardInput:(NSString *)text;
@end