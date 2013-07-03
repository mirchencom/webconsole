//
//  AppDelegate.m
//  PluginTest
//
//  Created by Roben Kleene on 7/2/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *plugInPath = [[NSBundle mainBundle] builtInPlugInsPath];
    NSLog(@"plugInPath = %@", plugInPath);
    
    // Insert code here to initialize your application
}

@end
