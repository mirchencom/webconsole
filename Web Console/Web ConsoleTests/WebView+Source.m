//
//  WebView+Source.m
//  Web Console
//
//  Created by Roben Kleene on 6/30/13.
//  Copyright (c) 2013 Roben Kleene. All rights reserved.
//

#import "WebView+Source.h"

@implementation WebView (Source)

- (NSString *)wcl_source {
    return [(DOMHTMLElement *)[[[self mainFrame] DOMDocument] documentElement] outerHTML];
}
@end
