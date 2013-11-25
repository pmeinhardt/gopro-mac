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

@property (nonatomic, retain, readonly) NSString *IP;
@property (nonatomic, assign, readonly) NSUInteger port;

- (id)initWithIP:(NSString *)ipaddr port:(NSUInteger)port password:(NSString *)password;
- (id)initWithIP:(NSString *)ipaddr password:(NSString *)password;
- (id)initWithPassword:(NSString *)password;

- (NSString *)webAddress;

- (BOOL)startCapture;
- (BOOL)stopCapture;

- (BOOL)setVideoMode;
- (BOOL)setPhotoMode;

- (BOOL)sync;

@end

@interface GoProCameraStatusTransformer : NSValueTransformer
@end
