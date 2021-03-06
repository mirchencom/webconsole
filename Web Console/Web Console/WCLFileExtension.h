//
//  WCLFileExtension.h
//  PluginEditorPrototype
//
//  Created by Roben Kleene on 3/23/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@class Plugin;

extern NSString * __nonnull const WCLFileExtensionPluginsKey;
extern NSString * __nonnull const WCLFileExtensionSuffixKey;

NS_ASSUME_NONNULL_BEGIN
@interface WCLFileExtension : NSObject
- (id)initWithSuffix:(NSString *)extension;
@property (nonatomic, strong, readonly) NSString *suffix;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, strong, nullable) Plugin *selectedPlugin;
@property (nonatomic, strong) NSArrayController *pluginsArrayController;
#pragma mark Required Key-Value Coding To-Many Relationship Compliance
- (NSArray<Plugin *> *)plugins;
- (void)insertObject:(Plugin *)plugin inPluginsAtIndex:(NSUInteger)index;
- (void)insertPlugins:(NSArray *)pluginsArray atIndexes:(NSIndexSet *)indexes;
- (void)removeObjectFromPluginsAtIndex:(NSUInteger)index;
- (void)removePluginsAtIndexes:(NSIndexSet *)indexes;
@end
NS_ASSUME_NONNULL_END
