//
//  Plugin.h
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plugin : NSObject
- (id)initWithPath:(NSString *)path;
- (NSString *)name;
- (void)runWithArguments:(NSArray *)arguments inDirectoryPath:(NSString *)directoryPath;
- (void)readFromStandardInput:(NSString *)text;
@end