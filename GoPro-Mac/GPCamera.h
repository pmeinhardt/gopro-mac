//
//  GPCamera.h
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/13/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPCameraStatus : NSObject

@property (nonatomic, assign, readonly) NSInteger videoCount;
@property (nonatomic, assign, readonly) NSInteger photoCount;

@end

@interface GPCamera : NSObject

@property (nonatomic, retain, readonly) GPCameraStatus *status;

- (id)initWithIP:(NSString *)ipaddress password:(NSString *)password;
- (id)initWithPassword:(NSString *)password;

- (BOOL)startCapture;
- (BOOL)stopCapture;

- (BOOL)setVideoMode;
- (BOOL)setPhotoMode;

- (BOOL)sync;

@end

@interface GPCameraStatusTransformer : NSValueTransformer
@end
