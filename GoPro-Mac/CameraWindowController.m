//
//  CameraWindowController.m
//  GoPro Mac
//
//  Created by Paul Meinhardt on 11/16/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "CameraWindowController.h"

@interface CameraWindowController ()

@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) NSInvocationOperation *operation;

- (void)camexec:(SEL)action;
- (void)done;

@end

@implementation CameraWindowController

- (void)dealloc
{
    [self.operation removeObserver:self forKeyPath:@"isFinished"];
    [self.queue cancelAllOperations];

    [self.camera release];
    [self.queue release];

    [super dealloc];
}

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:1];
    }
    return self;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isFinished"] && [object isKindOfClass:[NSInvocationOperation class]]) {
        [self performSelectorOnMainThread:@selector(done) withObject:nil waitUntilDone:NO];
    }
}

- (void)camexec:(SEL)action
{
    assert([NSThread isMainThread]);

    if (self.operation != nil) {
        return; // allow only one operation at a time
    }

    self.loading = YES;

    self.operation = [[[NSInvocationOperation alloc] initWithTarget:self.camera selector:action object:nil] autorelease];
    [self.operation addObserver:self forKeyPath:@"isFinished" options:0 context:self.queue];
    [self.queue addOperation:self.operation];
}

- (void)done
{
    [self.operation removeObserver:self forKeyPath:@"isFinished"];
    self.operation = nil;

    self.loading = NO;
}

#pragma mark - IBAction

- (IBAction)sync:(id)sender
{
    [self camexec:@selector(sync)];
}

- (IBAction)capture:(id)sender
{
    [self camexec:@selector(startCapture)];
}

- (IBAction)setMode:(id)sender
{
    NSPopUpButton *button = (NSPopUpButton *)sender;

    switch (button.indexOfSelectedItem) {
        case 0:
            [self camexec:@selector(setVideoMode)];
            break;

        case 1:
            [self camexec:@selector(setPhotoMode)];
            break;

        default:
            // nothing
            break;
    }
}

@end
