//
//  NSWindow+GPExtensions.m
//  GoPro
//
//  Created by Paul Meinhardt on 11/17/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "NSWindow+GPExtensions.h"

@implementation NSWindow (GPExtensions)

- (void)shake
{
    int shakes = 3;
    float duration = 0.5f;
    float strength = 0.05f;

    NSRect frame = self.frame;

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, NSMinX(frame), NSMinY(frame));

    int index;
    for (index = 0; index < shakes; ++index) {
        CGPathAddLineToPoint(path, NULL, NSMinX(frame) - frame.size.width * strength, NSMinY(frame));
        CGPathAddLineToPoint(path, NULL, NSMinX(frame) + frame.size.width * strength, NSMinY(frame));
    }

    CGPathCloseSubpath(path);

    animation.path = path;
    animation.duration = duration;

    [self setAnimations:[NSDictionary dictionaryWithObject:animation forKey:@"frameOrigin"]];
    [self.animator setFrameOrigin:frame.origin];

    CGPathRelease(path);
}

@end
