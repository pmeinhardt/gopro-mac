//
//  GoProCamera.h
//  GoPro
//
//  Created by Paul Meinhardt on 11/13/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoProCameraStatus : NSObject

@property (nonatomic, assign, readonly) NSInteger videoCount;
@property (nonatomic, assign, readonly) NSInteger photoCount;

@end

@interface GoProCamera : NSObject

@property (nonatomic, retain, readonly) GoProCameraStatus *status;

- (id)initWithIP:(NSString *)ipaddress password:(NSString *)password;
- (id)initWithPassword:(NSString *)password;

- (NSString *)address;

- (BOOL)startCapture;
- (BOOL)stopCapture;

- (BOOL)setVideoMode;
- (BOOL)setPhotoMode;

- (BOOL)sync;

@end

@interface GoProCameraStatusTransformer : NSValueTransformer
@end
