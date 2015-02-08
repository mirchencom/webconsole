//
//  PluginManager.h
//  PluginTest
//
//  Created by Roben Kleene on 7/3/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Plugin;
@class MultiCollectionController;

@interface WCLPluginsManager : NSObject
- (instancetype)initWithPlugins:(NSArray *)plugins;
@property (nonatomic, strong) MultiCollectionController *pluginsController;
@property (nonatomic, strong) Plugin *defaultNewPlugin;
#pragma mark Required Key-Value Coding To-Many Relationship Compliance
- (NSArray *)plugins;
- (void)insertObject:(Plugin *)plugin inPluginsAtIndex:(NSUInteger)index;
- (void)insertPlugins:(NSArray *)pluginsArray atIndexes:(NSIndexSet *)indexes;
- (void)removeObjectFromPluginsAtIndex:(NSUInteger)index;
- (void)removePluginsAtIndexes:(NSIndexSet *)indexes;
@end
