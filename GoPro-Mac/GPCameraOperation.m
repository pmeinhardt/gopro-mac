//
//  GPCameraOperation.m
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/18/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "GPCameraOperation.h"

@implementation GPCameraOperation

- (void)dealloc
{
    [self.camera release];
    [super dealloc];
}

- (void)main
{
    self.succeeded = (BOOL)[self.camera performSelector:self.action withObject:nil];
}

@end
