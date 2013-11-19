//
//  GPCameraOperation.h
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/18/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GPCamera.h"

@interface GPCameraOperation : NSOperation

@property (nonatomic, retain) GPCamera *camera;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) BOOL succeeded;

@end
