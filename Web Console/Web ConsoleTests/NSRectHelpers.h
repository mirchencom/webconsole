//
//  NSRectHelpers.h
//  Web Console
//
//  Created by Roben Kleene on 1/1/14.
//  Copyright (c) 2014 Roben Kleene. All rights reserved.
//

NS_INLINE BOOL NSSizeEqualToSize(NSSize size1, NSSize size2)
{
    return (size1.height == size2.height) && (size1.width == size2.width);
}

NS_INLINE BOOL NSPointEqualToPoint(NSPoint point1, NSPoint point2)
{
    return (point1.x == point2.x) && (point1.y == point2.y);
}

NS_INLINE BOOL NSRectEqualToRect(NSRect rect1, NSRect rect2)
{
    return NSPointEqualToPoint(rect1.origin, rect2.origin) && NSSizeEqualToSize(rect1.size, rect2.size);
}
