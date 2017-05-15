//
//  WCLPlugin+Validation.h
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 3/15/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import "WCLPlugin.h"

NS_ASSUME_NONNULL_BEGIN
@interface WCLPlugin (Validation)
#pragma mark Name
+ (BOOL)nameContainsOnlyValidCharacters:(NSString *)name;
- (BOOL)nameIsValid:(NSString *)name;
#pragma mark File Extensions
- (BOOL)extensionsAreValid:(NSArray *)extensions;
+ (NSArray *)validExtensionsFromExtensions:(NSArray *)extensions;
@end
NS_ASSUME_NONNULL_END
