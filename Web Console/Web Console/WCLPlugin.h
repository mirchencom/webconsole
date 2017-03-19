//
//  Plugin.h
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface WCLPlugin : NSObject
@property (nonatomic, assign, getter = isDefaultNewPlugin) BOOL defaultNewPlugin;
#pragma mark Validation
- (BOOL)validateExtensions:(_Nonnull id * _Nonnull)ioValue error:(NSError * __autoreleasing *)outError;
- (BOOL)validateName:(_Nonnull id * _Nonnull)ioValue error:(NSError * __autoreleasing *)outError;
@end
NS_ASSUME_NONNULL_END
