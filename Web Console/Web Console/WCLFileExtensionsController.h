//
//  WCLFileExtensionController.h
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 3/11/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WCLFileExtension;
@class PluginsManager;

NS_ASSUME_NONNULL_BEGIN
@interface WCLFileExtensionsController : NSObject
@property (nonatomic, strong, readonly) PluginsManager *pluginsManager;
- (instancetype)initWithPluginsManager:(PluginsManager *)pluginsManager;
- (NSArray *)suffixes;
- (nullable WCLFileExtension *)fileExtensionForSuffix:(NSString *)extension;
#pragma mark Required Key-Value Coding To-Many Relationship Compliance
- (NSArray *)fileExtensions;
- (void)insertObject:(WCLFileExtension *)fileExtension inFileExtensionsAtIndex:(NSUInteger)index;
- (void)insertFileExtensions:(NSArray *)fileExtensionsArray atIndexes:(NSIndexSet *)indexes;
- (void)removeObjectFromFileExtensionsAtIndex:(NSUInteger)index;
- (void)removeFileExtensionsAtIndexes:(NSIndexSet *)indexes;
@end
NS_ASSUME_NONNULL_END
