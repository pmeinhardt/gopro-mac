//
//  CameraWindowController.m
//  GoPro
//
//  Created by Paul Meinhardt on 11/16/13.
//  Copyright (c) 2013 Paul Meinhardt. All rights reserved.
//

#import "CameraWindowController.h"

#import "BrowserWindowController.h"

#import <dispatch/dispatch.h>

static void *PlayerItemStatusContext = &PlayerItemStatusContext;
static void *PlayerLayerReadyForDisplay = &PlayerLayerReadyForDisplay;

@interface CameraWindowController ()

// Camera operation and operation-queue
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) NSInvocationOperation *operation;

// File browser window controller
@property (nonatomic, retain, readonly) BrowserWindowController *browserWindowController;

//
- (void)camexec:(SEL)action;
- (void)done;

- (void)startPreview;
- (void)pausePreview;

- (void)loaded:(AVURLAsset *)asset keys:(NSArray *)keys;

@end

@implementation CameraWindowController

@synthesize browserWindowController = _browserWindowController;

- (void)dealloc
{
    [_browserWindowController.window close];
    [self removeObserver:self forKeyPath:@"player.currentItem.status"];
    [self removeObserver:self forKeyPath:@"layer.readyForDisplay"];
    [self.operation removeObserver:self forKeyPath:@"isFinished"];
    [self.queue cancelAllOperations];
    [self.player pause];

    [_browserWindowController release];
    [self.operation release];
    [self.queue release];
    [self.player release];
    [self.layer release];
    [self.camera release];

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

- (void)windowDidLoad
{
    [super windowDidLoad];

    // Configure the view
    [self.screen.layer setBackgroundColor:CGColorGetConstantColor(kCGColorBlack)];

    // Set up the AVPlayer, add status observers
    [self setPlayer:[[[AVPlayer alloc] init] autorelease]];
    [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew context:PlayerItemStatusContext];

    // TODO: initiate differently?
    [self startPreview];
}

#pragma mark -

- (BrowserWindowController *)browserWindowController
{
    if (_browserWindowController == nil) {
        _browserWindowController = [[BrowserWindowController alloc] initWithWindowNibName:@"BrowserWindow"];
    }

    return _browserWindowController;
}

#pragma mark - Playback

- (void)startPreview
{
    // Create an asset with our URL, asychronously load its tracks, duration,
    // and whether it's playable or protected. When that loading is complete,
    // play the asset with a player.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.camera.webAddress, @"/live/amba.m3u8"]];

    AVURLAsset *asset = [AVAsset assetWithURL:url];
    NSArray *keys = [NSArray arrayWithObjects:@"playable", @"hasProtectedContent", @"tracks", @"duration", nil];

    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        // The asset invokes its completion handler on an arbitrary queue
        // when loading is complete. Because we want to access our AVPlayer,
        // we must dispatch our handler to the main queue.
        dispatch_async(dispatch_get_main_queue(), ^{
			[self loaded:asset keys:keys];
		});
    }];
}

- (void)pausePreview
{
    [self.player pause];
}

- (void)loaded:(AVURLAsset *)asset keys:(NSArray *)keys
{
    NSError *error;

    // AVAsset for our URL has finished loading of values for the specified keys.
    // First test wether the values of each of the keys have been successfully loaded.
    for (NSString *key in keys) {
        if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {
            NSLog(@"ERROR: Could not load asset key \"%@\": %@", key, error); // TODO: handle
            return;
        }
    }

    if (![asset isPlayable]) {
        NSLog(@"ERROR: Cannot play this asset: %@", asset); // TODO: handle
        return;
    }

    // This seems to always return 0, even if we can play a video:
    //if ([asset tracksWithMediaType:AVMediaTypeVideo].count == 0) {
    //    NSLog(@"ERROR: Asset has no video tracks: %@", asset);
    //    return;
    //}

    // We can play this asset. Now set up an AVPlayerLayer,
    // add it to the view, but hide it until ready for display.
    self.layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.layer.frame = self.screen.layer.bounds;
    self.layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    self.layer.hidden = YES;

    [self.screen.layer addSublayer:self.layer];

    [self addObserver:self forKeyPath:@"layer.readyForDisplay" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:PlayerLayerReadyForDisplay];

    // Create an AVPlayerItem, make it our player's current item.
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    [self.player replaceCurrentItemWithPlayerItem:item];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == self.queue) {
        if ([object isKindOfClass:[NSInvocationOperation class]] && [keyPath isEqualToString:@"isFinished"]) {
            [self performSelectorOnMainThread:@selector(done) withObject:nil waitUntilDone:NO];
        }
    } else if (context == PlayerItemStatusContext) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"INFO: Player item status unknown"); // TODO: handle
                break;

            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"INFO: Player item ready to play");
                [self.player play];
                break;

            case AVPlayerItemStatusFailed:
                NSLog(@"ERROR: Player item status failed"); // TODO: handle
                break;

            default:
                NSLog(@"ERROR: Unhandled player item status");
                break;
        }
    } else if (context == PlayerLayerReadyForDisplay) {
        if ([[change objectForKey:NSKeyValueChangeNewKey] boolValue] == YES) {
			// The AVPlayerLayer is ready for display.
			self.layer.hidden = NO;
		}
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
- (IBAction)browse:(id)sender
{
    BrowserWindowController *controller = self.browserWindowController;
    [controller setBaseURL:[NSURL URLWithString:self.camera.webAddress]];
    [controller showWindow:sender];
}

@end
