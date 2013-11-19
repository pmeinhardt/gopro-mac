//
//  GPCamera.m
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/13/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "GPCamera.h"

#import "libgopro.h"

@interface GPCameraStatus ()

@property (nonatomic, assign) NSInteger videoCount;
@property (nonatomic, assign) NSInteger photoCount;

- (id)initWithStatus:(gopro_status *)status;
- (void)updateWithStatus:(gopro_status *)status;

@end

@implementation GPCameraStatus

- (id)initWithStatus:(gopro_status *)status
{
    self = [super init];
    if (self) {
        [self updateWithStatus:status];
    }
    return self;
}

- (void)updateWithStatus:(gopro_status *)status
{
    if (status == NULL) return;

    [self setVideoCount:(NSInteger)status->video_count];
    [self setPhotoCount:(NSInteger)status->photo_count];
}

@end

@interface GPCamera ()

@property (nonatomic, assign, readonly) gopro_camera *camera;

@end

@implementation GPCamera

@synthesize camera = _camera;
@synthesize status = _status;

- (void)dealloc
{
    if (self.camera != NULL) gopro_camera_free(self.camera);

    [self.status release];
    [super dealloc];
}

- (id)initWithIP:(NSString *)ipaddress password:(NSString *)password
{
    self = [super init];
    if (self) {
        _camera = gopro_camera_create((char *)[ipaddress UTF8String], (char *)[password UTF8String]);
        _status = [[GPCameraStatus alloc] init];
    }
    return self;
}

- (id)initWithPassword:(NSString *)password {
    self = [super init];
    if (self) {
        _camera = gopro_camera_create_default((char *)[password UTF8String]);
        _status = [[GPCameraStatus alloc] init];
    }
    return self;
}

- (BOOL)startCapture
{
    NSLog(@"start capture");
    [NSThread sleepForTimeInterval:1.0f];
    return YES; // TODO: remove mock return

    int err = gopro_camera_start_capture(self.camera);
    return err == GOPRO_SUCCESS;
}

- (BOOL)stopCapture
{
    NSLog(@"stop capture");
    [NSThread sleepForTimeInterval:1.0f];
    return YES; // TODO: remove mock return

    int err = gopro_camera_stop_capture(self.camera);
    return err == GOPRO_SUCCESS;
}

- (BOOL)setVideoMode
{
    NSLog(@"set video mode");
    [NSThread sleepForTimeInterval:1.0f];
    return YES; // TODO: remove mock return

    int err = gopro_camera_set_video_mode(self.camera);
    return err == GOPRO_SUCCESS;
}

- (BOOL)setPhotoMode
{
    NSLog(@"set photo mode");
    [NSThread sleepForTimeInterval:1.0f];
    return YES; // TODO: remove mock return

    int err = gopro_camera_set_photo_mode(self.camera);
    return err == GOPRO_SUCCESS;
}

- (BOOL)sync
{
    gopro_status status;

    [NSThread sleepForTimeInterval:2.0f];
    int err = GOPRO_SUCCESS;
    status.video_count = rand();
    status.photo_count = rand();// TODO: remove mock return

    // int err = gopro_camera_get_status(self.camera, &status);

    if (err != GOPRO_SUCCESS) {
        return NO;
    }

    [self willChangeValueForKey:@"status"];
    [self.status updateWithStatus:&status];
    [self didChangeValueForKey:@"status"];

    return YES;
}

@end

@implementation GPCameraStatusTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    GPCameraStatus *status = (GPCameraStatus *)value;
    return [NSString stringWithFormat:@"%ld videos, %ld photos", status.videoCount, status.photoCount];
}

@end
